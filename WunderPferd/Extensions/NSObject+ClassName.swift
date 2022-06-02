//
//  NSObject+ClassName.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 28.04.2022.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}
