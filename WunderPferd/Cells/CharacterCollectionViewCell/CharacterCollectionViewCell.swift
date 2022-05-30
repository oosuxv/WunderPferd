//
//  CharacterCollectionViewswift
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
    
    func setup(_ character: Character) {
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.masksToBounds = true
        containerView.layer.borderColor = CGColor.init(red: 86.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        nameLabel.text = character.name
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = genderLabel.font.pointSize / nameLabel.font.pointSize
        speciesLabel.text = character.species
        genderLabel.text = character.gender.representedValue
        id = character.image
        imageView.image = UIImage(named: "defaultCharacterImage")
        hud.show(in: imageView, animated: false, afterDelay: 0.001)
    }
}
