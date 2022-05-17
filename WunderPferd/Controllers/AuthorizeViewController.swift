//
//  ViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 08.04.2022.
//

import UIKit
import JGProgressHUD

class AuthorizeViewController: TitledScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = authScrollView
        titleLabel = authTitleLabel
        textFields = [authLoginField, authPasswordField]
        authScrollView.delegate = self
        
        hud.textLabel.text = "Connecting"
        hud.vibrancyEnabled = true
    }
    
    @IBAction func registerTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(identifier: RegisterViewController.className)
        registerVC.modalPresentationStyle = .fullScreen
        show(registerVC, sender: self)
    }
    
    @IBAction func enterTap(_ sender: Any) {
        guard let username = authLoginField.text,
              let password = authPasswordField.text else {
            BoldSnackBar.make(in: self.view, message: "Заполните все поля.", duration: .lengthLong).show()
            return
        }
        hud.show(in: self.view)
        pnm.login(username, password) {
            response, error in
            self.hud.dismiss()
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
    let hud = JGProgressHUD()
    
    @IBOutlet weak var authScrollView: UIScrollView!
    @IBOutlet weak var authTitleLabel: UILabel!
    @IBOutlet weak var authLoginField: UITextField!
    @IBOutlet weak var authPasswordField: UITextField!
}


