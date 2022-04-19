//
//  UITableViewCell+NibName.swift
//  WunderPferd
//
//  Created by Student1 on 19.04.2022.
//

import UIKit

extension UITableViewCell {
    static var nibName: String {
        String(describing: Self.self)
    }
}
