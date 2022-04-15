//
//  RegistrationViewController.swift
//  WunderPferd
//
//  Created by Student1 on 15.04.2022.
//

import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(scrollView.contentSize as Any)
//        scrollView.isTracking
//        scrollView.isDragging
//        scrollView.isDecelerating
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardDidHide() {
        scrollView.contentInset = .zero
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @objc func keyboardDidChange(notification: Notification) {
        print("wowza, hiding")
        var keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
            }
        scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegistrationViewController : UIScrollViewDelegate {
    
}
