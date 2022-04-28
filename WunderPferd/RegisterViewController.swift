//
//  RegisterViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit

class RegisterViewController: TitledScrollViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = regScrollView
        titleLabel = regTitleLabel
        textFields = regTextFields
        regScrollView.delegate = self
        
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
    
    @IBAction func doneTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(identifier: "UITabBarController")
        tabBarVC.modalPresentationStyle = .fullScreen
        show(tabBarVC, sender: self)
    }
    
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
