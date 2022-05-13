//
//  Character.swift
//  WunderPferd
//
//  Created by Student1 on 13.05.2022.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: Gender
}
