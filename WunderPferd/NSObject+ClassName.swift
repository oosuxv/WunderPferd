//
//  NSObject+ClassName.swift
//  WunderPferd
//
//  Created by Student1 on 22.04.2022.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}

