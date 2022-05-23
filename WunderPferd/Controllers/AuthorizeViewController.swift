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
    
    @IBAction func registerButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(identifier: RegisterViewController.className)
        registerVC.modalPresentationStyle = .fullScreen
        show(registerVC, sender: self)
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        guard let username = authLoginField.text,
              let password = authPasswordField.text else {
            ErrorMessageSnackBar.showMessage(in: view, message: "Заполните все поля.")
            return
        }
        hud.show(in: self.view)
        profileNetworkManager.login(username, password) {
            [weak self] response, error in
            self?.hud.dismiss()
            if let response = response {
                let profileDataInteractor = ProfileDataInteractor()
                profileDataInteractor.loginUser(token: response.token, userId: response.userId)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarVC = storyboard.instantiateViewController(identifier: "UITabBarController")
                tabBarVC.modalPresentationStyle = .fullScreen
                self?.show(tabBarVC, sender: self)
                return
            }
            ErrorMessageSnackBar.showMessage(in: self?.view, message: "Логин провалился")
        }
    }
    
    let profileNetworkManager: ProfileNetworkManager = NetworkManager()
    let hud = JGProgressHUD()
    
    @IBOutlet weak var authScrollView: UIScrollView!
    @IBOutlet weak var authTitleLabel: UILabel!
    @IBOutlet weak var authLoginField: UITextField!
    @IBOutlet weak var authPasswordField: UITextField!
}


