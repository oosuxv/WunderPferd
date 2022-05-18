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
    
    private func validateFields() -> Bool {
        guard let username = regTextFields[usernameFieldId].text,
                let password = regTextFields[passwordFieldId].text,
                let passwordConfirmation = regTextFields[passwordConfirmationFieldId].text else {
            ErrorNotificationSnackBar.make(in: self.view, message: "Заполните все поля.", duration: .lengthLong).show()
            return false
        }
        if username == "" || password == "" || passwordConfirmation == "" {
            ErrorNotificationSnackBar.make(in: self.view, message: "Заполните все поля.", duration: .lengthLong).show()
            return false
        }
        if password != passwordConfirmation {
            ErrorNotificationSnackBar.make(in: self.view, message: "Пароли не совпадают.", duration: .lengthLong).show()
            return false
        }
        return true
    }
    
    private func registerUser(username: String, password: String) {
        pnm.register(username, password) {
            response, error in
            self.hud.dismiss(animated: true)
            if let error = error {
                ErrorNotificationSnackBar.make(in: self.view, message: "Ошибка соединения.", duration: .lengthLong).show()
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
    
    @IBAction func doneTap(_ sender: Any) {
        guard let username = regTextFields[usernameFieldId].text,
                let password = regTextFields[passwordFieldId].text,
                validateFields() else {
            return
        }
        hud.show(in: self.view)
        pnm.checkUsername(username) {
            response, error in
            if let error = error {
                self.hud.dismiss(animated: true)
                ErrorNotificationSnackBar.make(in: self.view, message: "Ошибка соединения. Попробуйте позже.", duration: .lengthLong).show()
                print(error)
            } else if let response = response {
                if response.result == .free {
                    self.registerUser(username: username, password: password)
                } else {
                    self.hud.dismiss(animated: true)
                    ErrorNotificationSnackBar.make(in: self.view, message: response.result.representedValue, duration: .lengthLong).show()
                }
            }
        }
    }
    
    let usernameFieldId = 0
    let passwordFieldId = 1
    let passwordConfirmationFieldId = 2
    
    let pnm: ProfileNetworkManager = NetworkManager()
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
