//
//  StudyScrollViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

class StudyScrollViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
                
    @objc func keyboardWillShow(notification: Notification) {
        var keyboardHeight = 0.0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        if let currentField = textFields.first(where: { $0.isFirstResponder }) {
            let scrollTo = CGPoint(x: 0, y: currentField.frame.origin.y - keyboardHeight + stackOffset)
            scrollView.setContentOffset(scrollTo, animated: true)
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] {
            print("keyboard animation time: \(animationDuration) seconds")
        }
    }
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    var stackOffset = 0.0
    let scaleCoef = 500.0
}

extension StudyScrollViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scale = 1 + scrollView.contentOffset.y / scaleCoef
        let leftEdgeCompensation = scrollView.contentSize.width * (scale - 1) / 2
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
                                .concatenating(CGAffineTransform(translationX: leftEdgeCompensation, y: 0))
    }
}
