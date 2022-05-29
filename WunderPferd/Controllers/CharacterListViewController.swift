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
            flowLayout.sectionInset = .init(top: 28, left: 24, bottom: 28, right: 24)
            flowLayout.minimumLineSpacing = 28
            flowLayout.minimumInteritemSpacing = 20
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
        
        setupCell(cell, character)
        
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
    
    private func setupCell(_ cell: CharacterCollectionViewCell, _ character: Character) {
        cell.containerView.layer.cornerRadius = 15
        cell.containerView.layer.borderWidth = 1
        cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.borderColor = CGColor.init(red: 86.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.layer.masksToBounds = true
        
        cell.nameLabel.text = character.name
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.nameLabel.minimumScaleFactor = cell.genderLabel.font.pointSize / cell.nameLabel.font.pointSize
        cell.speciesLabel.text = character.species
        cell.genderLabel.text = character.gender.representedValue
        cell.id = character.image
        cell.imageView.image = UIImage(named: "defaultCharacterImage")
        cell.hud.show(in: cell.imageView, animated: false, afterDelay: 0.001)
    }
    
}
