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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        return signInVC
    }
    
    // MARK:- Private Methods
    private func isValidData() -> Bool {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            return true
        }
        showAlert(title: "Missed data", message: "Please enter all textfields above")
        return false
    }
    
    private func login(completion: @escaping () -> Void) {
        APIManager.login(with: emailTextField.text!, password: passwordTextField.text!) { [weak self] (error, loginData) in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlert(title: "Can't log in", message: "Wrong email or password")
            } else if let loginData = loginData {
                UserDefaultsManager.shared().token = loginData.token
                completion()
            }
        }
    }
    
    private func goToTodoListVC() {
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    // MARK:- IBAction Methods
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if isValidData() {
            login() {
                self.goToTodoListVC()
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

