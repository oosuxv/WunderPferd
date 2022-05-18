//
//  BoldSnackBar.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.05.2022.
//

import UIKit
import SnackBar

class ErrorMessageSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .orange
        style.textColor = .black
        style.font = style.font.withSize(30)
        return style
    }
    
    static func showMessage(in view: UIView, message: String) {
        make(in: view, message: message, duration: .lengthLong).show()
    }
}
