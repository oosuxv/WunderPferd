//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Student1 on 17.05.2022.
//

import Foundation

struct ServiceLocator {
    
    static let imageLoadingService = ImageService(networkManager: imageNetworkLocator())

    
    static func characterNetworkManager() -> CharacterNetworkManager {
        return NetworkManager()
    }
    
    static func imageNetworkLocator() -> ImageNetworkManager {
        return NetworkManager();
    }
    
    static func imageService() -> ImageServiceProtocol {
        imageLoadingService
    }
}
