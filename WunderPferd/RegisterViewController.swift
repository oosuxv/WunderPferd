//
//  RegisterViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        textFields.forEach { field in
            field.delegate = self
            if field == textFields.last {
                field.returnKeyType = .done
            } else {
                field.returnKeyType = .next
            }
        }
        textFields.first?.becomeFirstResponder()
    }
    
    @IBOutlet var textFields: [UITextField]!
  
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ currentField: UITextField) -> Bool {
        if textFields.last == currentField {
            currentField.resignFirstResponder()
            return true
        }
        if let index = textFields.firstIndex(where: {textField in textField == currentField}) {
            textFields[index + 1].becomeFirstResponder()
        }
        return true
    }
}
