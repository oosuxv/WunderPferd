//
//  ViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 08.04.2022.
//

import UIKit

class AuthorizeViewController: TitledScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = authScrollView
        titleLabel = authTitleLabel
        textFields = authTextFields
        authScrollView.delegate = self
    }
    
    @IBAction func registerTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(identifier: RegisterViewController.className)
        registerVC.modalPresentationStyle = .fullScreen
        show(registerVC, sender: self)
    }
    
    @IBOutlet var authTextFields: [UITextField]!
    @IBOutlet weak var authScrollView: UIScrollView!
    @IBOutlet weak var authTitleLabel: UILabel!
    
    
}


