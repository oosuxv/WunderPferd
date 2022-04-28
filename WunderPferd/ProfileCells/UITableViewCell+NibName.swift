//
//  UITableViewCell+NibName.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

extension UITableViewCell {
    static var nibName: String {
        String(describing: Self.self)
    }
}
