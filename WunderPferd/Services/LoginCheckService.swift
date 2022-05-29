//
//  LoginCheckService.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 29.05.2022.
//

import Foundation

protocol LoginCheckService {
    func userIsLoggedIn() -> Bool
}
