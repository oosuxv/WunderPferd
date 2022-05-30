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
        
        authLoginField.setAppStyle()
        authPasswordField.setAppStyle()
    }
    
    @IBAction func registerButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyboard.instantiateViewController(identifier: RegisterViewController.className)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(registerViewController)
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        guard let username = authLoginField.text,
              let password = authPasswordField.text else {
            ErrorMessageSnackBar.showMessage(in: view, message: "Заполните все поля.")
            return
        }
        hud.show(in: self.view)
        authorizeNetworkManager.login(username, password) {
            [weak self] response, error in
            guard let self = self else { return }
            self.hud.dismiss()
            if let response = response {
                self.loginDataManager.loginUser(token: response.token, userId: response.userId)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootTabBarController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(rootTabBarController)
                return
            }
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Логин провалился")
        }
    }
    
    let authorizeNetworkManager: AuthorizeNetworkManager = ServiceLocator.authorizeNetworkManager()
    let loginDataManager: LoginDataManager = ServiceLocator.loginDataManager()
    let hud = JGProgressHUD()
    
    @IBOutlet weak var authScrollView: UIScrollView!
    @IBOutlet weak var authTitleLabel: UILabel!
    @IBOutlet weak var authLoginField: UITextField!
    @IBOutlet weak var authPasswordField: UITextField!
}


