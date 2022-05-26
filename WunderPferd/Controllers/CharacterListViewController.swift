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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CharacterCollectionViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.className)
        
        guard let location = location else {
            return
        }
        title = "Жители локации \"\(location.name)\""
        characterNetworkManager.getMultipleCharacters(ids: getCharacterIds()) {
            [weak self] characters, error in
            guard let self = self else {
                return
            }
            if let characters = characters {
                self.characters.append(contentsOf: characters)
                self.collectionView.reloadData()
            } else {
                print(error as Any)
            }
        }
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
}

extension CharacterListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        guard let _ = location,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.className, for: indexPath) as? CharacterCollectionViewCell else {
            print("what?")
            return UICollectionViewCell()
        }
        cell.nameLabel.text = characters[indexPath.row].name
        cell.speciesLabel.text = characters[indexPath.row].species
        cell.genderLabel.text = characters[indexPath.row].gender.representedValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
}

extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // TODO: realise
}
