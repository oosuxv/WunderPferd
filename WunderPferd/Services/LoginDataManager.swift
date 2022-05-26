//
//  LoginDataManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 26.05.2022.
//

import Foundation

protocol LoginDataManager {
    
    func loginUser(token: String, userId: String)
}
