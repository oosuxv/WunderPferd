//
//  ProfileNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation

protocol ProfileNetworkManager {
    
    func checkUsername(_ username: String, completion: ((UsernameResponse?, Error?) -> ())?)
    func register(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
    func login(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
    func getProfile(profileId: String, completion: ((Profile?, Error?) -> ())?)
}
