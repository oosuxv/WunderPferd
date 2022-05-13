//
//  Gender.swift
//  WunderPferd
//
//  Created by Student1 on 13.05.2022.
//

import Foundation

enum Gender: String, Decodable {
    case Female = "Female"
    case Male = "Male"
    case Genderless
    case unknown
    
    var representedValue: String {
        switch self {
        case .Female:
            return "Женский"
        case .Male:
            return "Мужской"
        case .Genderless:
            return "Бесполый"
        case .unknown:
            return "Неизвестный"
        }
    }
}
