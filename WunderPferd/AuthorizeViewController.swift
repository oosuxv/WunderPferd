//
//  ViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 08.04.2022.
//

import UIKit

class AuthorizeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        UserDefaults.standard.set(true, forKey: "testKey")
        let boolFromUD = UserDefaults.standard.bool(forKey: "testKey")
        print(boolFromUD)
        
        // 2
        // coredata magic record
        
        // realm.io
        
        // keychain - тут хранимый вещи требующие безопасности
        
        // для работы с данными всегда заводит data manager класс
        // сделать инициализатор
        
        // зависимости
        // alamofire например
        // cocoapods - самый старй менеджер зависимостей
        // cartage - посвежее, инкто не использует
        // swift package manager spm
        
    }
    
    func printPipint(string: String) {
        print(string)
    }
}

