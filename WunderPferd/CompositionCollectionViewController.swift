//
//  CompositionCollectionViewController.swift
//  WunderPferd
//
//  Created by Student1 on 22.04.2022.
//

import UIKit

class CompositionCollectionViewController: UIViewController {
    
    let networkManager = ServiceLocator.characterNetworkManager()
    let storageManager = StorageManager()
    
    func olololPrint(_ string: String, completion: () -> ()) {
      print(string)
      completion()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let semaphore = DispatchSemaphore(value: 1)
        let dispatchQueue = DispatchQueue(label: "mabel")
        dispatchQueue.async {
            semaphore.wait()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.olololPrint("dql") {
                    semaphore.signal()
                }
            }
        }
        dispatchQueue.async {
            print("second")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(PLCollectionViewCell.self, forCellWithReuseIdentifier: PLCollectionViewCell.className)
        
        let nib = UINib(nibName: TestCollectionViewCell.className, bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: TestCollectionViewCell.className)
        collectionView.collectionViewLayout = layout()
        title = "джигурда"
        
//        let completion: (Character?, Error?) -> () = {
//            responce, error in
//            if let error = error {
//                print(error)
//            } else {
//                print(responce?.id as Any)
//                print(responce?.name as Any)
//                print(responce?.gender.representedValue as Any)
//                print(responce?.species as Any)
//                print(responce?.status.representedValue as Any)
//            }
//        }
        
        
//        networkManager.performRequest(url: "https://rickandmortyapi.com/api/character/2",
//                                                 method: .get,
//                                      onRequestCompleted: completion)
        
        let oldToken = storageManager.loadFromKeychain(key: .token)
        print(oldToken as Any)
        
        storageManager.saveToKeychain("ololo", key: .token)
        
        let newToken = storageManager.loadFromKeychain(key: .token)
        print(newToken as Any)
        
        networkManager.getCharacter(id: 2) {
            responce, error in
            if let error = error {
                print(error)
            } else {
                print(responce?.id as Any)
                print(responce?.name as Any)
                print(responce?.gender.representedValue as Any)
                print(responce?.species as Any)
                print(responce?.status.representedValue as Any)
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var aButtonTrailingConstraint: NSLayoutConstraint!

    
    func layout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), // ширина итем относительно группы, в которой он находится равна 1
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        // если возвращать несколько секций в разных направлениях
//        return UICollectionViewCompositionalLayoutSectionProvider(proivder())
    }
    
    @IBAction func tapA(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut) { [weak self] in
            self?.aButtonTrailingConstraint.constant = 100
            self?.view.setNeedsLayout() // заставляет layout пересчитаться
            self?.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    //    func proivder() -> UICollectionViewCompositionalLayoutSectionProvider {
//        return { int, environment in
//            if int == 0 {
//
//            }
//        }
//    }
}

extension CompositionCollectionViewController: UICollectionViewDataSource {
    
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

extension CompositionCollectionViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item: \(indexPath.item)")
    }

}
