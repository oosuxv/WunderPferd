//
//  ViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 08.04.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        someView.layer.cornerRadius = 12
        someView.layer.borderWidth = 6
        someView.layer.borderColor = UIColor.green.cgColor
        let view = UIView(frame: .init(x: 20, y: 20, width: 45, height: 45))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        button.addTarget(self, action: #selector(tap2), for: .touchUpInside)  //self - sdfg
        button.setTitle( "shmitle", for: .normal)
        textField.becomeFirstResponder()  // auto focus
        textField.delegate = self
        tap.addTarget(self, action: #selector(tap2))
        someView.addGestureRecognizer(tap)
        testClosure = {[weak self] text, editable, field in
            guard let self = self else {
                return false
            }
            print("\(text) and \(field?.text ?? "")")
            self.printCompare(text1: text, text2: field?.text ?? "")
            return editable && text == field?.text
        }
        
        let result = testClosure?("ok", textField.isEditing, textField)
        print(result as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardDidChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func tap2() {
        print("tap-tap")
        textField.resignFirstResponder()
    }
    
    @objc func keyboardDidChange(Sender: Notification) {
        print(Sender)
    }
    
    func printCompare(text1: String, text2: String) {
        print("\(text1 == text2)")

    }
    
    @IBOutlet weak var someView: UIView! // bad naming
    @IBOutlet weak var button: UIButton! // bad naming
    @IBOutlet weak var textField: UITextField! // bad naming
    @IBOutlet weak var tap: UITapGestureRecognizer!
    
    var testClosure: ((String, Bool, UITextField?) -> Bool)?
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // можно ли нажать кнопку
        textField.resignFirstResponder()
        return true
    }
    
    // срабатывает при изменение поля и мониторит какие изменения прилетели и возвращает стоит ли их примернять
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text ?? "")
        print(string)
        return true
    }
}
