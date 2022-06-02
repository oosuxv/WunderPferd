//
//  StorageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 16.05.2022.
//

import Foundation
import KeychainAccess

class StorageManager {
    
    enum StorageManagerKey: String {
        case token
        case userId
        case username
        case notFirstLaunch
    }
    
    private struct Constants {
        static let serviceId = "StorageManagerKeychain.Service.Id"
    }
    
    func saveToKeychain(_ string: String, key: StorageManagerKey) {
        let keychain = Keychain(service: Constants.serviceId)
        do {
            try keychain.set(string, key: key.rawValue)
        } catch {
            ServiceLocator.logger.info("save to keychain failed: \(error.localizedDescription)")
        }
    }
    
    func loadFromKeychain(key: StorageManagerKey) -> String? {
        let keychain = Keychain(service: Constants.serviceId)
        do {
            let result = try keychain.getString(key.rawValue)
            return result
        } catch {
            ServiceLocator.logger.info("loadFromKeychain failed: \(error.localizedDescription)")
        }
        return nil
    }
    
    func removeFromKeychain(key: StorageManagerKey) {
        let keychain = Keychain(service: Constants.serviceId)
        do {
            try keychain.remove(key.rawValue)
        } catch {
            ServiceLocator.logger.info("removeFromKeychain failed: \(error.localizedDescription)")
        }
    }
    
    func saveBoolToUserDefaults(bool: Bool, key: StorageManagerKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }
    
    func loadUserDefaultsBool(key: StorageManagerKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func saveStringToUserDefaults(_ string: String, key: StorageManagerKey) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }
    
    func loadUserDefaultsString(key: StorageManagerKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    func cleanKeychain() {
        let keychain = Keychain(service: Constants.serviceId)
        do {
            try keychain.removeAll()
        } catch {
            ServiceLocator.logger.info("cleanKeychain failed: \(error.localizedDescription)")
        }
    }
    
    func cleanUserDefaults() {
        UserDefaults.standard.removeObject(forKey: StorageManagerKey.username.rawValue)
    }
}

extension StorageManager: FirstStartService {
    func processFirstStart() {
        if !loadUserDefaultsBool(key: .notFirstLaunch) {
            cleanKeychain()
            saveBoolToUserDefaults(bool: true, key: .notFirstLaunch)
        }
    }
}

extension StorageManager: LoginDataManager {
    func loginUser(token: String, userId: String) {
        saveToKeychain(token, key: .token)
        saveToKeychain(userId, key: .userId)
        cleanUserDefaults();
    }
}

extension StorageManager: UserDataManager {
    func loadUsername() -> String? {
        loadUserDefaultsString(key: .username)
    }
    
    func loadUserId() -> String? {
        loadFromKeychain(key: .userId)
    }
    
    func saveUsername(username: String) {
        saveStringToUserDefaults(username, key: .username)
    }
    
    func logoutUser() {
        removeFromKeychain(key: .token)
        removeFromKeychain(key: .userId)
        removeFromKeychain(key: .username)
    }
}

extension StorageManager: LoginCheckService {
    func userIsLoggedIn() -> Bool {
        if let _ = loadFromKeychain(key: .userId),
           let _ = loadFromKeychain(key: .token) {
            return true
        }
        return false
    }
}
