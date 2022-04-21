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
        
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFields.first?.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardDidChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidHide() {
        scrollView.contentInset = .zero
        print("khkh")
    }
                
    @objc func keyboardDidChange(notification: Notification) {
        var keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        print("wow, keyboard did change")
        scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var scrollView: UIScrollView!
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
