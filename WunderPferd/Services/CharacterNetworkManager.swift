//
//  CharacterNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 27.05.2022.
//

import Foundation

protocol CharacterNetworkManager {
    
    func getCharacter(url: String, completion: ((Character?, Error?) -> ())?)
}
