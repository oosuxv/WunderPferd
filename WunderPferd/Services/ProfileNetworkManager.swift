//
//  ProfileNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation

protocol ProfileNetworkManager {
    
    func getProfile(profileId: String, completion: ((Profile?, Error?) -> ())?)
}
