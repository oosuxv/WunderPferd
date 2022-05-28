//
//  UserDataManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 26.05.2022.
//

import Foundation

protocol UserDataManager {
    func loadUsername() -> String?
    func loadUserId() -> String?
    func saveUsername(username: String)
    func logoutUser()
}
