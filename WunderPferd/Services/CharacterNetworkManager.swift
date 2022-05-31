//
//  CharacterNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 27.05.2022.
//

import Foundation

protocol CharacterNetworkManager {
    
    func getCharacter(url: String, completion: ((Character?, Error?) -> ())?)
    func getCharacter(id: String, completion: ((Character?, Error?) -> ())?)
    func getMultipleCharacters(idListCommaSeparated ids: String, completion: (([Character]?, Error?) -> ())?)
}
