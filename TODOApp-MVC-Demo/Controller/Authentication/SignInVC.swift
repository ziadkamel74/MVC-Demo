//
//  SignInVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- UIKit Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
    
    // MARK:- IBAction Methods
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if isValidData() {
            login() {
                self.switchToMainState()
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

extension SignInVC {
    // MARK:- Private Methods
    private func isValidData() -> Bool {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            return true
        }
        showAlert(title: "Missed data", message: "Please enter all textfields above")
        return false
    }
    
    private func login(completion: @escaping () -> Void) {
        self.view.showLoader()
        let user = UserData(email: emailTextField.text, password: passwordTextField.text)
        APIManager.login(with: user) { [weak self] (response) in
            switch response {
            case .failure(let error):
                self?.showAlert(title: "Can't log in", message: error.localizedDescription)
            case .success(let result):
                UserDefaultsManager.shared().token = result.token
                completion()
            }
            self?.view.hideLoader()
        }
    }
    
    private func switchToMainState() {
        let toDoListVC = ToDoListVC.create()
        let navigationController = UINavigationController(rootViewController: toDoListVC)
        AppDelegate.shared().window?.rootViewController = navigationController
    }
}
