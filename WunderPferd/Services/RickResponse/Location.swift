//
//  Location.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    var page: Int?
}
