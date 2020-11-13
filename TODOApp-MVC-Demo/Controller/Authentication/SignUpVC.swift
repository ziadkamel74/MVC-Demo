//
//  SignUpVC.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- UIKit Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }    

    // MARK:- Public Methods
    class func create() -> SignUpVC {
        let signUpVC: SignUpVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signUpVC)
        return signUpVC
    }
    
    // MARK:- IBAction Methods
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        if isValidData() {
            registerUser() {
                self.switchToMainState()
            }
        }
    }
}

extension SignUpVC {
    // MARK:- Private Methodss
    private func isValidData() -> Bool {
        if let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text?.trimmed, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let age = ageTextField.text, !age.isEmpty {
            
            switch name.isValidName {
            case true: break
            case false:
                showAlert(title: ValidationType.name.error.title, message: ValidationType.name.error.message)
            }
            
            switch email.isValidEmail {
            case true: break
            case false:
                showAlert(title: ValidationType.email.error.title, message: ValidationType.email.error.message)
                return false
            }
            
            switch password.isValidPassword {
            case true: break
            case false:
                showAlert(title: ValidationType.password.error.title, message: ValidationType.password.error.message)
                return false
            }
            
            switch age.isValidAge {
            case true: break
            case false:
                showAlert(title: ValidationType.age.error.title, message: ValidationType.age.error.message)
                return false
            }
            
            return true
        }
        
        showAlert(title: "Missed data", message: "Please enter all textfields above")
        return false
    }
    
    private func registerUser(completion: @escaping () -> Void) {
        self.view.showLoader()
        let user = UserData(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, age: Int(ageTextField.text!))
        APIManager.register(with: user) { [weak self] (response) in
            switch response {
            case .failure(let error):
                self?.showAlert(title: "Can't sign up", message: error.localizedDescription)
            case .success(let response):
                UserDefaultsManager.shared().token = response.token
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
