//
//  CharacterNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 27.05.2022.
//

import Foundation

protocol CharacterNetworkManager {
    
    func getMultipleCharacters(ids: String, completion: (([Character]?, Error?) -> ())?)
}
