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
    }
    
    @objc func tap2() {
        print("tap-tap")
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var someView: UIView! // bad naming
    @IBOutlet weak var button: UIButton! // bad naming
    @IBOutlet weak var textField: UITextField! // bad naming
    @IBOutlet weak var tap: UITapGestureRecognizer!
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // можно ли нажать кнопку
        textField.resignFirstResponder()
        if fields.last
        return true
    }
    
    // срабатывает при изменение поля и мониторит какие изменения прилетели и возвращает стоит ли их примернять
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text ?? "")
        print(string)
        return true
    }
}
