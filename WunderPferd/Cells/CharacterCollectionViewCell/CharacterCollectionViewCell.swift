//
//  CharacterCollectionViewCell.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 25.05.2022.
//

import UIKit
import JGProgressHUD

class CharacterCollectionViewCell: UICollectionViewCell {

    var id: String?
    let hud = JGProgressHUD()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
}
