//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.05.2022.
//

import Foundation

final class ServiceLocator {

    static var shared = ServiceLocator() // Singleton

    let storageManager: StorageManager
    let networkManager: ProfileNetworkManager
    let profileImageManager: ProfileImageManager
    
    init(storageManager: StorageManager = KeychainDefaultsStorageManager(),
         networkManager: ProfileNetworkManager = NetworkManager(),
         profileImageManager: ProfileImageManager = FileProfileImageManager()) {
        self.storageManager = storageManager
        self.networkManager = networkManager
        self.profileImageManager = profileImageManager
    }
}
