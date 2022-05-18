//
//  ImageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 01.05.2022.
//

import UIKit

class ProfileDataManager {
    private let fileName = "profile.png"
    private static let usernameKey = "WunderPferd.profile.username";
    
    var image: UIImage? {
        get {
            if let dirPath = documentDirectoryPath() {
                let imageUrl = dirPath.appendingPathComponent(fileName)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image
            }
            return nil
        }
        
        set(newImage) {
            if let pngData = newImage?.pngData(),
                let path = documentDirectoryPath()?.appendingPathComponent(fileName) {
                try? pngData.write(to: path)
            }
        }
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
    
    func requestUsername(completion: @escaping (String) -> ()) {
        if let username = UserDefaults.standard.string(forKey: ProfileDataManager.usernameKey) {
            completion(username)
        } else {
            let storageManager = StorageManager()
            if let userId = storageManager.loadFromKeychain(key: .userId) {
                let networkManager = NetworkManager()
                networkManager.getProfile(profileId: userId) {
                    response, error in
                    if let response = response {
                        UserDefaults.standard.setValue(response.username, forKey: ProfileDataManager.usernameKey)
                        completion(response.username)
                        return
                    }
                    // TODO: log error
                }
            } else {
                // TODO: log error
            }
        }
    }
}
