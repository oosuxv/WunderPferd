//
//  Character.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 25.05.2022.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let species: String
    let gender: Gender
    let image: String
}
