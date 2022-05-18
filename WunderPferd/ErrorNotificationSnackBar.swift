//
//  BoldSnackBar.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.05.2022.
//

import Foundation
import SnackBar

class ErrorNotificationSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .orange
        style.textColor = .black
        style.font = style.font.withSize(30)
        return style
    }
}
