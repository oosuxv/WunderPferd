//
//  ProfileViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 22.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    var profileDataInteractor = ServiceLocator.profileDataInteractor()
    var registrationDate = Date.now.addingTimeInterval(-86400)
    var preferredColor = UIColor.blue
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        profileDataInteractor.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authorizeViewController = storyboard.instantiateViewController(identifier: AuthorizeViewController.className)

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authorizeViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: ProfileTitleTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: ProfileTitleTableViewCell.className)
        tableView.register(UINib(nibName: ProfileDataTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: ProfileDataTableViewCell.className)
        tableView.register(UINib(nibName: ProfileColorTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: ProfileColorTableViewCell.className)
    }
    
    @objc func loadImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            loadImage()
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
            cell.wideImageView.backgroundColor = preferredColor
            
            if let image = profileDataInteractor.image {
                cell.circledImageView.image = image
                cell.wideImageView.image = image
            }
            
            profileDataInteractor.requestUsername(completion: {
                username, error in
                if let username = username {
                    cell.loginLabel.text = username
                } else {
                    ServiceLocator.logger.info("username request failed: \(error?.localizedDescription ?? "")")
                }
            })
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDataTableViewCell.className) as? ProfileDataTableViewCell else {
                return UITableViewCell()
            }
            cell.attribute.text = "Дата Регистрации"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/YYYY"
            cell.value.text = formatter.string(from: registrationDate)
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileColorTableViewCell.className) as? ProfileColorTableViewCell else {
                return UITableViewCell()
            }
            cell.attributeLabel.text = "Цвет профиля"
            cell.colorView.layer.cornerRadius = 8
            cell.colorView.backgroundColor = preferredColor
            return cell
        }
        return UITableViewCell()
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    // TODO: realize
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        profileDataInteractor.image = image
        self.tableView.reloadSections(IndexSet([0]), with: .automatic)
        dismiss(animated: true)
    }
}
