//
//  ProfileVC.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 11/2/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Properties
    var profileCells: [ProfileCell] = []
        
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "User Profile"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserData()
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileVC)
        return profileVC
    }
    
    // MARK:- Private Methods
    private func getUserData() {
        APIManager.getUserData { [weak self] (error, userData) in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            } else if let userData = userData {
                self?.configureModels(with: userData)
            }
        }
    }
    
    private func configureModels(with userData: UserData) {
        profileCells = [ProfileCell(title: "Name: " + userData.name, textColor: nil, handler: nil),
                        ProfileCell(title: "Age: " + String(userData.age), textColor: nil, handler: nil),
                        ProfileCell(title: "Email: " + userData.email, textColor: nil, handler: nil),
                        ProfileCell(title: "Log Out", textColor: .systemRed, handler: didTapLogOut)]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func didTapLogOut() {
        
        let logOutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] (action) in
            APIManager.logOut { [weak self] (logedOut) in
                if logedOut {
                    UserDefaultsManager.shared().token = nil
                    self?.switchToAuthState()
                }
            }
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(logOutAlert, animated: true)
    }
    
    private func switchToAuthState() {
        let signInVC = SignInVC.create()
        let navigationController = UINavigationController(rootViewController: signInVC)
        AppDelegate.shared().window?.rootViewController = navigationController
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.profileCell, for: indexPath)
        cell.textLabel?.text = profileCells[indexPath.row].title
        cell.textLabel?.textColor = profileCells[indexPath.row].textColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        profileCells[indexPath.row].handler?()
    }
    
}
