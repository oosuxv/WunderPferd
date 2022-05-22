//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.05.2022.
//

import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator() // Singleton

    var storageManager: StorageManager
    var networkManager: ProfileNetworkManager
    var profileImageManager: ProfileImageManager
    var profileDataInteractor: ProfileDataInteractor
    
    init(storageManager: StorageManager = KeychainDefaultsStorageManager(),
         networkManager: ProfileNetworkManager = NetworkManager(),
         profileImageManager: ProfileImageManager = FileProfileImageManager()) {
        self.storageManager = storageManager
        self.networkManager = networkManager
        self.profileImageManager = profileImageManager
        self.profileDataInteractor = DefaultProfileDataInteractor(storageManager: storageManager, networkManager: networkManager, profileImageManager: profileImageManager)
    }
}
