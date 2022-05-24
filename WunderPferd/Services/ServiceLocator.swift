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
    var profileNetworkManager: ProfileNetworkManager
    var profileImageManager: ProfileImageManager
    var profileDataInteractor: ProfileDataInteractor
    var rickNetworkManager: RickNetworkManager
    
    init(storageManager: StorageManager = KeychainDefaultsStorageManager(),
         profileNetworkManager: ProfileNetworkManager = NetworkManager(),
         profileImageManager: ProfileImageManager = FileProfileImageManager(),
         rickNetworkManager: RickNetworkManager = NetworkManager()
    ) {
        self.storageManager = storageManager
        self.profileNetworkManager = profileNetworkManager
        self.profileImageManager = profileImageManager
        self.rickNetworkManager = rickNetworkManager
        self.profileDataInteractor = DefaultProfileDataInteractor(storageManager: storageManager, networkManager: profileNetworkManager, profileImageManager: profileImageManager)
    }
}
