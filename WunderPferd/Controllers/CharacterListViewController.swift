//
//  CharacterListViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 25.05.2022.
//

import UIKit

class CharacterListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let characterNetworkManager = ServiceLocator.characterNetworkManager()
    private let imageService = ServiceLocator.imageService()
    private var location: Location?
    private var characters: [Character] = []
    private var requestQueue = OperationQueue()
    
    private struct Constants {
        static let minimumInteritemSpacing = 20.0
        static let horizontalInset = 24.0
        static let verticalInset = 24.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestQueue.maxConcurrentOperationCount = 10
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CharacterCollectionViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.className)
        
        guard let location = location else {
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки локации")
            return
        }
        
        guard location.residents.count > 0 else {
            title = "Пустая локация \"\(location.name)\""
            return
        }
        title = "Жители локации \"\(location.name)\""
        requestCharactersParallel()
    }
    
    func setLocation(_ location: Location) {
        self.location = location
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension:.fractionalHeight(1.02))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(Constants.minimumInteritemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: Constants.verticalInset,
                                      leading: Constants.horizontalInset,
                                      bottom: Constants.verticalInset,
                                      trailing: Constants.horizontalInset)
        section.interGroupSpacing = Constants.verticalInset
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    private func requestCharactersParallel() {
        guard let location = location else {
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки локации")
            return
        }
        location.residents.forEach {
            residentUrl in
            requestQueue.addOperation {
                self.characterNetworkManager.getCharacter(url: residentUrl) {
                    character, error in
                    guard let character = character else {
                        ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки персонажа \(error?.localizedDescription ?? "")")
                        return
                    }
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let self = self else { return }
                        self.characters.append(character)
                        let indexPath = IndexPath(item: self.characters.count - 1, section: 0)
                        self.collectionView.insertItems(at: [indexPath])
                    }
                }
            }
        }
    }
}

extension CharacterListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _ = location,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.className, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let character = characters[indexPath.row]
        
        cell.setup(character)
        
        imageService.getImage(url: character.image) {
            [weak cell] image, url in
            guard let cell = cell else {
                return
            }
            cell.hud.dismiss()
            guard let image = image,
                  let url = url,
                  cell.id == url else {
                return
            }
            cell.imageView.image = image
            cell.imageView.layer.masksToBounds = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
}
