//
//  RegisterViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit
import SnackBar
import JGProgressHUD

class RegisterViewController: TitledScrollViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = regScrollView
        titleLabel = regTitleLabel
        textFields = regTextFields
        regScrollView.delegate = self
        
        hud.textLabel.text = "Connecting"
        hud.vibrancyEnabled = true
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        regTextFields.forEach { field in
            field.delegate = self
            if field == regTextFields.last {
                field.returnKeyType = .done
            } else {
                field.returnKeyType = .next
            }
        }
        
        stackOffset = stackView.frame.origin.y
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        regTextFields.first?.becomeFirstResponder()
    }
    
    private func hasNoValidationErrors() -> Bool {
        guard let username = regTextFields[usernameFieldId].text,
                let password = regTextFields[passwordFieldId].text,
                let passwordConfirmation = regTextFields[passwordConfirmationFieldId].text else {
            ErrorMessageSnackBar.showMessage(in: view, message: "Заполните все поля.")
            return false
        }
        if username == "" || password == "" || passwordConfirmation == "" {
            ErrorMessageSnackBar.showMessage(in: view, message: "Заполните все поля.")
            return false
        }
        if password != passwordConfirmation {
            ErrorMessageSnackBar.showMessage(in: view, message: "Пароли не совпадают.")
            return false
        }
        return true
    }
    
    private func registerUser(username: String, password: String) {
        registerNetworkManager.register(username, password) {
            [weak self] response, error in
            guard let self = self else { return }
            self.hud.dismiss(animated: true)
            if let response = response {
                self.loginDataManager.loginUser(token: response.token, userId: response.userId)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarVC = storyboard.instantiateViewController(identifier: "UITabBarController")
                tabBarVC.modalPresentationStyle = .fullScreen
                self.show(tabBarVC, sender: self)
                return
            }
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка соединения.")
        }
    }
    
    @IBAction func doneButtonTap(_ sender: Any) {
        guard hasNoValidationErrors(),
                let username = regTextFields[usernameFieldId].text,
                let password = regTextFields[passwordFieldId].text else {
            return
        }
        hud.show(in: self.view)
        registerNetworkManager.checkUsername(username) {
            [weak self] response, error in
            guard let self = self else { return }
            if let response = response {
                if response.result == .free {
                    self.registerUser(username: username, password: password)
                } else {
                    self.hud.dismiss(animated: true)
                    ErrorMessageSnackBar.showMessage(in: self.view, message: response.result.representedValue)
                }
                return
            }
            self.hud.dismiss(animated: true)
            ErrorMessageSnackBar.showMessage(in: self.view, message: "Ошибка соединения. Попробуйте позже.")
        }
    }
    
    let usernameFieldId = 0
    let passwordFieldId = 1
    let passwordConfirmationFieldId = 2
    
    let registerNetworkManager: RegisterNetworkManager = ServiceLocator.registerNetworkManager()
    let loginDataManager: LoginDataManager = ServiceLocator.loginDataManager()
    let hud = JGProgressHUD()

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var regTextFields: [UITextField]!
    @IBOutlet weak var regScrollView: UIScrollView!
    @IBOutlet weak var regTitleLabel: UILabel!
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ currentField: UITextField) -> Bool {
        if regTextFields.last == currentField {
            currentField.resignFirstResponder()
            return true
        }
        if let index = regTextFields.firstIndex(where: {textField in textField == currentField}) {
            regTextFields[index + 1].becomeFirstResponder()
        }
        return true
    }
}
