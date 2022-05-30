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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = .init(top: 28, left: 5, bottom: 28, right: 5)
            flowLayout.minimumLineSpacing = 28
            flowLayout.minimumInteritemSpacing = 18
        }
        
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
        requestCharacters()
    }
    
    func setLocation(_ location: Location) {
        self.location = location
    }
    
    private func getCharacterIds() -> String {
        var result = ""
        if let location = location {
            for characterUrl in location.residents {
                var id = ""
                for symbol in characterUrl.reversed() {
                    if symbol.isNumber {
                        id.insert(symbol, at: id.startIndex)
                    } else {
                        break
                    }
                }
                if result.count != 0 {
                    result.append(",")
                }
                result.append(contentsOf: id)
            }
        }
        return result
    }
    
    private func requestCharacters() {
        guard let location = location else {
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки локации")
            return
        }
        if location.residents.count == 1 {
            characterNetworkManager.getCharacter(id: getCharacterIds()) {
                [weak self] character, error in
                guard let self = self else {
                    return
                }
                if let character = character {
                    self.characters.append(character)
                    self.collectionView.reloadData()
                } else {
                    ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки жителей")
                    ServiceLocator.logger.info("character load failed: \(error?.localizedDescription ?? "")")
                }
            }
        }
        if location.residents.count > 1 {
            characterNetworkManager.getMultipleCharacters(idListCommaSeparated: getCharacterIds()) {
                [weak self] characters, error in
                guard let self = self else {
                    return
                }
                if let characters = characters {
                    self.characters.append(contentsOf: characters)
                    self.collectionView.reloadData()
                } else {
                    ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка загрузки жителей")
                    ServiceLocator.logger.info("character load failed: \(error?.localizedDescription ?? "")")
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
