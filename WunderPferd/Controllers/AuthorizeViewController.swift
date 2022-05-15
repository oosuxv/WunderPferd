//
//  ViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 08.04.2022.
//

import UIKit

class AuthorizeViewController: TitledScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = authScrollView
        titleLabel = authTitleLabel
        textFields = authTextFields
        authScrollView.delegate = self
    }
    
    @IBAction func registerTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(identifier: RegisterViewController.className)
        registerVC.modalPresentationStyle = .fullScreen
        show(registerVC, sender: self)
    }
    
    @IBAction func enterTap(_ sender: Any) {
        guard let username = authTextFields[usernameFieldId].text,
              let password = authTextFields[passwordFieldId].text else {
            BoldSnackBar.make(in: self.view, message: "Заполните все поля.", duration: .lengthLong).show()
            return
        }
        pnm.login(username, password) {
            response, error in
            if let error = error {
                BoldSnackBar.make(in: self.view, message: "Логин провалился", duration: .lengthLong).show()
                print(error)
            } else if let response = response {
                let storageManager = StorageManager()
                storageManager.saveToKeychain(response.token, key: .token)
                storageManager.saveToKeychain(response.userId, key: .userId)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarVC = storyboard.instantiateViewController(identifier: "UITabBarController")
                tabBarVC.modalPresentationStyle = .fullScreen
                self.show(tabBarVC, sender: self)
            }
        }
    }
    
    let pnm: ProfileNetworkManager = NetworkManager()
    
    let usernameFieldId = 0
    let passwordFieldId = 1
    
    @IBOutlet var authTextFields: [UITextField]!
    @IBOutlet weak var authScrollView: UIScrollView!
    @IBOutlet weak var authTitleLabel: UILabel!
}


