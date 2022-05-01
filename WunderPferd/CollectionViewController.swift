//
//  CollectionViewController.swift
//  WunderPferd
//
//  Created by Student1 on 22.04.2022.
//

import UIKit

class CollectionViewController: UIViewController {
    
    let networkdManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(PLCollectionViewCell.self, forCellWithReuseIdentifier: PLCollectionViewCell.className)
        
        let nib = UINib(nibName: TestCollectionViewCell.className, bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: TestCollectionViewCell.className)
        
        networkdManager.performRequest(
            url: "https://rickandmortyapi.com/api/character/2",
            method: .get,
            onRequestCompleted:
        on)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        guard indexPath.item < 5 else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.className, for: indexPath) as? TestCollectionViewCell {
                cell.title.text = "Section: \(indexPath.section)"
                cell.subtitle.text = "Item: \(indexPath.item)"
                return cell
            }
            return UICollectionViewCell()
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PLCollectionViewCell.className, for: indexPath) as? PLCollectionViewCell {
            cell.customView.backgroundColor = .systemTeal
            return cell
        }
        return UICollectionViewCell()  //  тут будет краш, так не делать
    }
}

extension CollectionViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item: \(indexPath.item)")
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let screenWidth = UIScreen.main.bounds.width
            let sideSize = screenWidth / 2
            return .init(width: sideSize, height: sideSize)
        }
}
