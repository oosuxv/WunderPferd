//
//  RegisterNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 26.05.2022.
//

import Foundation

protocol RegisterNetworkManager {
    
    func checkUsername(_ username: String, completion: ((UsernameResponse?, Error?) -> ())?)
    func register(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
}
