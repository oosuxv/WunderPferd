//
//  LocationsResponse.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation

struct LocationsResponse: Decodable {
    let results: [Location]
}
