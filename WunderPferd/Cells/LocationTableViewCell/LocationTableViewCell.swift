//
//  LocationTableViewCell.swift
//  WunderPferd
//
//  Created by Student1 on 19.04.2022.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}
