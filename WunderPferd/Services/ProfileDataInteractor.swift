//
//  ImageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 01.05.2022.
//

import UIKit

protocol ProfileDataInteractor {
    var image: UIImage? { get set }
    func requestUsername(completion: @escaping (String?, Error?) -> ())
}

class DefaultProfileDataInteractor: ProfileDataInteractor {
    private let userDataManager: UserDataManager
    private let profileNetworkManager: ProfileNetworkManager
    private let profileImageManager: ProfileImageManager
    
    init(userDataManager: UserDataManager,
         profileNetworkManager: ProfileNetworkManager,
         profileImageManager: ProfileImageManager) {
        self.userDataManager = userDataManager
        self.profileNetworkManager = profileNetworkManager
        self.profileImageManager = profileImageManager
    }

    var image: UIImage? {
        get {
            if let userId = userDataManager.loadUserId() {
                return profileImageManager.loadImage(userId: userId)
            } else {
                return nil
            }
        }
        
        set(newImage) {
            if let userId = userDataManager.loadUserId() {
                profileImageManager.saveImage(image: newImage, userId: userId)
            }
        }
    }
    
    func requestUsername(completion: @escaping (String?, Error?) -> ()) {
        if let username = userDataManager.loadUsername() {
            completion(username, nil)
        } else {
            if let userId = userDataManager.loadUserId() {
                profileNetworkManager.getProfile(profileId: userId) {
                    response, error in
                    if let response = response {
                        self.userDataManager.saveUsername(username: response.username)
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
}
