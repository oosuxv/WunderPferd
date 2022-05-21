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
            print(error as Any)
        }
    }
    
    func loadFromKeychain(key: StorageManagerKey) -> String? {
        let keychain = Keychain(service: Constants.serviceId)
        do {
            let result = try keychain.getString(key.rawValue)
            return result
        } catch {
            print(error as Any)
        }
        return nil
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
            print(error as Any)
        }
    }
    
    func cleanUserDefaults() {
        UserDefaults.standard.removeObject(forKey: StorageManagerKey.username.rawValue)
    }
}
