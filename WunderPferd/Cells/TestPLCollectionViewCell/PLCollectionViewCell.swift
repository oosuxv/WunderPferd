//
//  PLCollectionViewCell.swift
//  WunderPferd
//
//  Created by Student1 on 22.04.2022.
//

import UIKit

class PLCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        customView = UIView()
        super.init(frame: frame)
        initialSet()
    }
    
    required init?(coder: NSCoder) {
        customView = UIView()
        super.init(coder: coder)
        initialSet()
    }
    
    func initialSet() {
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        NSLayoutConstraint.activate(
            [
                customView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
                customView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
                customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
            ]
        )
    }
    
    let customView: UIView
}
