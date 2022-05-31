//
//  ConViewController.swift
//  WunderPferd
//
//  Created by Student1 on 31.05.2022.
//

import UIKit
import AutoLayoutSugar

class ConViewController: UIViewController {
    
    var subViewTopConstraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subView = UIView()
        subView.backgroundColor = .purple
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subViewTopConstraint = subView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        subViewTopConstraint?.isActive = true
        subView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        subView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        subView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let subView2 = UIView()
        subView2.backgroundColor = .cyan
        subView2.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(subView2)
        NSLayoutConstraint.activate([
            subView2.topAnchor.constraint(equalTo: subView.topAnchor, constant: 10),
            subView2.leftAnchor.constraint(equalTo: subView.leftAnchor, constant: 50),
            subView2.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -10),
            subView2.rightAnchor.constraint(equalTo: subView.rightAnchor, constant: -50),
        ])
        
        let subView3 = UIView()
        subView2.addSubview(subView3)
        subView3.backgroundColor = .red
        subView3.prepareForAutoLayout()
//            .pinToSuperview(with: .init(top: 5, left: 10, bottom: 5, right: 10))
            .top(20)
            .left(20)
            .bottom(20)
            .right(25)
        subView.layer.shadowOpacity = 1
        subView.layer.shadowRadius = 10
        subView.layer.shadowColor = UIColor.black.cgColor
        // тени в ячейках таблицы layoutSublayers ячейки
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
