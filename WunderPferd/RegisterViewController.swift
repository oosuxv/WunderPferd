//
//  RegisterViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.04.2022.
//

import UIKit

class RegisterViewController: StudyScrollViewController {

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
        
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFields.first?.becomeFirstResponder()
    }
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

extension RegisterViewController : UIScrollViewDelegate {
}
