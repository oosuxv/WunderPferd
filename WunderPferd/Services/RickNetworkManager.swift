//
//  RickNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation

protocol RickNetworkManager {
    
    func getLocations(page: Int, completion: ((LocationsResponse?, Error?) -> ())?)
}
