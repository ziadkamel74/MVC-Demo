//
//  ProfileTableVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 11/5/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileTableVC: UITableViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getUserData()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileTableVC {
        let profileTableVC: ProfileTableVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileTableVC)
        return profileTableVC
    }
    
}

extension ProfileTableVC {
    // MARK:- Private Methods
    private func setupViews() {
        setupNavBar()
        setupImageButton()
    }
    
    private func setupImageButton() {
        userImageBtn.addTarget(self, action: #selector(didTapImageBtn), for: .touchUpInside)
        userImageBtn.layer.cornerRadius = userImageBtn.frame.width / 2
        userImageBtn.layer.masksToBounds = true
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Info", style: .done, target: self, action: #selector(didTapEditInfo))
    }
    
    private func getUserData() {
        self.view.showLoader()
        APIManager.getUserData { [weak self] (response) in
            switch response {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let userData):
                self?.showUserInfo(with: userData)
                guard let id = userData.id else { return }
                self?.getUserImage(with: id)
            }
            self?.view.hideLoader()
        }
    }
    
    private func showUserInfo(with userData: UserData) {
        guard let userName = userData.name,
            let userAge = userData.age else { return }
        configureImageLabel(with: userName)
        nameLabel.text = userData.name
        ageLabel.text = String(userAge)
        emailLabel.text = userData.email
    }
    
    /// Func to get initial charcters form first name and last name
    private func configureImageLabel(with name: String) {
        let initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        imageLabel.text = initials
    }
    
    private func getUserImage(with id: String) {
        self.view.showLoader()
        APIManager.getUserImage(with: id) { [weak self] (response) in
            switch response {
            case .failure:
                self?.imageLabel.isHidden = false
            case .success(let data):
                if let image = UIImage(data: data) {
                    self?.imageLabel.isHidden = true
                    self?.userImageBtn.setImage(image, for: .normal)
                }
            }
            self?.view.hideLoader()
        }
    }
    
    private func presentImagePicker() {
        // Picker instance
        let picker = UIImagePickerController()
        // Allow image cropping
        picker.allowsEditing = true
        // Setting delegate to self, delegation design pattern require conforming protocols
        picker.delegate = self
        // Presenting the image picker
        self.present(picker, animated: true, completion: nil)
    }
    
    private func uploadImage(with image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        self.view.showLoader()
        APIManager.uploadImage(with: imageData) { [weak self] (uploaded) in
            if uploaded {
                self?.userImageBtn.setImage(image, for: .normal)
            } else {
                self?.showAlert(title: "Connection Error", message: "Please try again later")
            }
            self?.view.hideLoader()
        }
    }
    
    private func deleteUserImage() {
        self.view.showLoader()
        APIManager.deleteUserImage { [weak self] (deleted) in
            if deleted {
                self?.imageLabel.isHidden = false
                self?.userImageBtn.setImage(UIImage(), for: .normal)
            } else {
                self?.imageLabel.isHidden = true
            }
            self?.view.hideLoader()
        }
    }
    
    private func updateUserProfile(name: String?, age: String?, email: String?) {
        let validName: String? = nameToUpdate(name)
        let validEmail: String? = emailToUpdate(email)
        let validAge: Int? = ageToUpdate(age)
        let user = UserData(name: validName, email: validEmail, age: validAge)
        
        self.view.showLoader()
        APIManager.updateUserProfile(user) { [weak self] (updated) in
            if updated {
                self?.getUserData()
            } else {
                self?.showAlert(title: "Connection error", message: "Please try again later")
            }
            self?.view.hideLoader()
        }
    }
    
    private func nameToUpdate(_ name: String?) -> String? {
        if let name = name, !name.isEmpty, name.isValidName {
            return name
        } else if let name = name, !name.isEmpty, !name.isValidName {
            showAlert(title: ValidationType.name.error.title, message: ValidationType.name.error.message)
        }
        return nil
    }
    
    private func emailToUpdate(_ email: String?) -> String? {
        if let email = email, !email.isEmpty, email.isValidEmail {
            return email
        } else if let email = email, !email.isEmpty, !email.isValidEmail {
            showAlert(title: ValidationType.email.error.title, message: ValidationType.email.error.message)
        }
        return nil
    }
    
    private func ageToUpdate(_ age: String?) -> Int? {
        if let age = age, !age.isEmpty, age.isValidAge {
            return Int(age)
        } else if let age = age, !age.isEmpty, !age.isValidAge {
            showAlert(title: ValidationType.age.error.title, message: ValidationType.age.error.message)
        }
        return nil
    }
    
    private func switchToAuthState() {
        let signInVC = SignInVC.create()
        let navigationController = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = navigationController
    }
    
    private func didTapLogOut() {
        let logOutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] (action) in
            self?.logOut()
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(logOutAlert, animated: true)
    }
    
    private func logOut() {
        self.view.showLoader()
        APIManager.logOut { [weak self] (loggedOut) in
            if loggedOut {
                UserDefaultsManager.shared().token = nil
                self?.switchToAuthState()
            } else {
                self?.showAlert(title: "Connection error", message: "Please try again later")
            }
            self?.view.hideLoader()
        }
    }
    
    private func didTapDeleteAccount() {
        
        let deleteAccAlert = UIAlertController(title: "Delete your Account", message: "Are you sure you want to delete your account?", preferredStyle: .actionSheet)
        deleteAccAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action) in
            self?.deleteAccount()
        }))
        
        deleteAccAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(deleteAccAlert, animated: true)
    }
    
    private func deleteAccount() {
        self.view.showLoader()
        APIManager.deleteUser { [weak self] (deleted) in
            if deleted {
                UserDefaultsManager.shared().token = nil
                self?.switchToAuthState()
            }
            self?.view.hideLoader()
        }
    }
    
    // MARK:- objc Methods
    @objc private func didTapEditInfo() {
        let editAlert = UIAlertController(title: "Edit Info", message: nil, preferredStyle: .alert)
        editAlert.addTextField { (textField) in
            textField.placeholder = "Name..."
        }
        editAlert.addTextField { (textField) in
            textField.placeholder = "Age..."
            textField.keyboardType = .numberPad
        }
        editAlert.addTextField { (textField) in
            textField.placeholder = "Email..."
            textField.keyboardType = .emailAddress
        }
        editAlert.addAction(UIAlertAction(title: "Save", style: .destructive, handler: { [weak self] (action) in
            
            let name = editAlert.textFields?[0].text, age = editAlert.textFields?[1].text, email = editAlert.textFields?[2].text
            self?.updateUserProfile(name: name, age: age, email: email)
            
        }))
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(editAlert, animated: true)
    }
    
    @objc private func didTapImageBtn() {
        let photoAlert = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        photoAlert.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { [weak self] (action) in
            self?.presentImagePicker()
        }))
        photoAlert.addAction(UIAlertAction(title: "Delete Picture", style: .destructive, handler: { [weak self] (action) in
            self?.deleteUserImage()
        }))
        photoAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(photoAlert, animated: true)
    }
    
}

extension ProfileTableVC {
    // MARK:- TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            didTapLogOut()
        case (2, 1):
            didTapDeleteAccount()
        default: break
        }
    }
}

extension ProfileTableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK:- ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        uploadImage(with: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss picker when user cancel
        picker.dismiss(animated: true, completion: nil)
    }
}
