//
//  ProfileViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    weak var wideImageView: UIImageView?
    weak var circledImageView: UIImageView?
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

        tableView.register(UINib(nibName: ProfileTitleTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: ProfileTitleTableViewCell.className)
        tableView.register(UINib(nibName: ProfileDataTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: ProfileDataTableViewCell.className)
    }
    
    @objc func loadImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    // TODO: realize
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTitleTableViewCell.className) as? ProfileTitleTableViewCell else {
                return UITableViewCell()
            }
            cell.circledImageView.layer.borderWidth = 5
            cell.circledImageView.layer.masksToBounds = false
            cell.circledImageView.layer.borderColor = UIColor.white.cgColor
            cell.circledImageView.layer.cornerRadius = cell.circledImageView.frame.height / 2
            cell.circledImageView.clipsToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadImage))
            cell.circledImageView.addGestureRecognizer(tapGestureRecognizer)
            
            self.circledImageView = cell.circledImageView
            self.wideImageView = cell.wideImageView
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDataTableViewCell.className) as? ProfileDataTableViewCell else {
                return UITableViewCell()
            }
            let tuple = source[indexPath.row]
            cell.attribute.text = tuple.0
            cell.value.text = tuple.1
            return cell
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    // TODO: realize
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        wideImageView?.image = image
        circledImageView?.image = image
        dismiss(animated: true)
    }
}
