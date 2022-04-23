//
//  ProfileViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var source: [(String, String)] = [
            ("first name", "Bob"),
            ("last name", "Bobson"),
            ("age", "8 month"),
            ("gender", "bender"),
            ("occupation", "no"),
            ("hobby", "eating")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: ProfileTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProfileTableViewCell.nibName)
    }
}

extension ProfileViewController: UITableViewDelegate {
    // TODO: realize
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.nibName) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let tuple = source[indexPath.row]
        cell.attribute.text = tuple.0
        cell.value.text = tuple.1
        return cell
    }
}
