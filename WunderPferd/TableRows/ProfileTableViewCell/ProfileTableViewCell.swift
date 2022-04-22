//
//  ProfileTableViewCell.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attribute: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
