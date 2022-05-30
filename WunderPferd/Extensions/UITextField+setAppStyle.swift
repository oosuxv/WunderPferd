//
//  UITextField+setAppStyle.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 30.05.2022.
//

import UIKit

extension UITextField {
    
    func setAppStyle() {
        layer.borderWidth = 2
        layer.borderColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.56)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
