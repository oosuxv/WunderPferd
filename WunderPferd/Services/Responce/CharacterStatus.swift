//
//  CharacterStatus.swift
//  WunderPferd
//
//  Created by Student1 on 13.05.2022.
//

import Foundation

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
    
    var representedValue: String {
        switch self {
        case .alive:
            return "Живой"
        case .dead:
            return "Мертвый"
        case .unknown:
            return "Неизвестный"
        }
    }
}
