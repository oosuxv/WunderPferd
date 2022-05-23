//
//  ImageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 01.05.2022.
//

import UIKit

class ProfileDataInteractor {
    lazy var storageManager = StorageManager()
    lazy var networkManager = NetworkManager()
    lazy var profileImageManager = ProfileImageManager()

    var image: UIImage? {
        get {
            if let userId = storageManager.loadFromKeychain(key: .userId) {
                return profileImageManager.loadImage(userId: userId)
            } else {
                return nil
            }
        }
        
        set(newImage) {
            if let userId = storageManager.loadFromKeychain(key: .userId) {
                profileImageManager.saveImage(image: newImage, userId: userId)
            }
        }
    }
    
    func requestUsername(completion: @escaping (String?, Error?) -> ()) {
        if let username = storageManager.loadUserDefaultsString(key: .username) {
            completion(username, nil)
        } else {
            if let userId = storageManager.loadFromKeychain(key: .userId) {
                networkManager.getProfile(profileId: userId) {
                    response, error in
                    if let response = response {
                        self.storageManager.saveStringToUserDefaults(response.username, key: .username)
                        completion(response.username, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            } else {
                let error = AppError(message: "userId is not present in Keychain")
                completion(nil, error)
            }
        }
    }
    
    func loginUser(token: String, userId: String) {
        storageManager.saveToKeychain(token, key: .token)
        storageManager.saveToKeychain(userId, key: .userId)
        storageManager.cleanUserDefaults();
    }
}
