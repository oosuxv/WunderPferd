//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Student1 on 17.05.2022.
//

import Foundation

struct ServiceLocator {
    
    static func characterNetworkManager() -> CharacterNetworkManager {
        return NetworkManager()
    }
}
