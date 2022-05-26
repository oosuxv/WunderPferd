//
//  ServiceLocator.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.05.2022.
//

import Foundation

final class ServiceLocator {
    
    static func firstStartService() -> FirstStartService {
        StorageManager()
    }
    
    static func authorizeNetworkManager() -> AuthorizeNetworkManager {
        NetworkManager()
    }
    
    static func registerNetworkManager() -> RegisterNetworkManager {
        NetworkManager()
    }

    static func profileNetworkManager() -> ProfileNetworkManager {
        NetworkManager()
    }
    
    static func profileImageManager() -> ProfileImageManager {
        FileProfileImageManager()
    }
    
    static func loginDataManager() -> LoginDataManager {
        StorageManager()
    }
    
    static func profileDataInteractor() -> ProfileDataInteractor {
        DefaultProfileDataInteractor(
            userDataManager: StorageManager(),
            profileNetworkManager: profileNetworkManager(),
            profileImageManager: profileImageManager()
        )
    }
    
    static func locationNetworkManager() -> LocationNetworkManager {
        NetworkManager()
    }
}
