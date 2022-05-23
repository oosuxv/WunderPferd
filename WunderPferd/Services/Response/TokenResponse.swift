//
//  TokenResponse.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 16.05.2022.
//

import Foundation

struct TokenResponse: Decodable {
    let token: String
    let userId: String
}
