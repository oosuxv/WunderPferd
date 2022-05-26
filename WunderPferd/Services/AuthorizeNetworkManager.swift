//
//  AuthorizeNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 26.05.2022.
//

import Foundation

protocol AuthorizeNetworkManager {
    
    func login(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
}
