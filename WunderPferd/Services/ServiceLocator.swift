//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.05.2022.
//

import Foundation

final class ServiceLocator {
    
    static func storageManager() -> StorageManager {
        return KeychainDefaultsStorageManager()
    }

    static func profileNetworkManager() -> ProfileNetworkManager {
        return NetworkManager()
    }
    
    static func profileImageManager() -> ProfileImageManager {
        return FileProfileImageManager()
    }
    
    static func profileDataInteractor() -> ProfileDataInteractor {
        return DefaultProfileDataInteractor(
            storageManager: storageManager(),
            networkManager: profileNetworkManager(),
            profileImageManager: profileImageManager()
        )
    }
    
    static func rickNetworkManager() -> RickNetworkManager {
        return NetworkManager()
    }
}
