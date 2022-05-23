//
//  AppError.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 23.05.2022.
//

import Foundation

struct AppError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? { return message }
}
