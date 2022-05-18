//
//  UsernameStatus.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 18.05.2022.
//

import Foundation

enum UsernameStatus: String, Decodable {
    case tooShort = "TooShort"
    case tooLong = "TooLong"
    case invalidCharacters = "InvalidCharacters"
    case taken = "Taken"
    case free = "Free"

    var representedValue: String {
        switch self {
        case .tooShort:
            return "имя пользователя короче 3 символов"
        case .tooLong:
            return "имя пользователя длиннее 16 символов"
        case .invalidCharacters:
            return "имя пользователя должно состоять только из a-z, _, ."
        case .taken:
            return "имя пользователя занято"
        case .free:
            return "имя пользователя свободно"
        }
    }
}
