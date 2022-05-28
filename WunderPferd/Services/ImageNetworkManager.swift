//
//  CharacterImageNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 27.05.2022.
//

import Foundation

protocol ImageNetworkManager {
    
    func getImage(url: String, completion: ((Data?, Error?) -> ())?)
}
