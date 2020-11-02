//
//  String+ValidData.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 10/31/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

enum ValidationType {
    case name, email, password, age
    
    var error: (title: String, message: String) {
        switch self {
            case .name:
            return ("Invalid Name", "Name should contain letters only, at least 3 characters and and at most 18 characters")
        case .email:
            return ("Invalid Email", "Email should be : example@mail.com")
        case .password:
            return ("Invalid Password", "Make sure password contains minimum 8 characters at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character")
        case .age:
            return ("Invalid Age", "Age should be more than 6")
        }
    }
}

extension String {
    
    var isValidName: Bool {
        guard self.count > 3, self.count < 18 else { return false }
        let regularExpressionForName = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        let testPassword = NSPredicate(format: "SELF MATCHES %@", regularExpressionForName)
        return testPassword.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let regularExpressionForPassword = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let testPassword = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPassword)
        return testPassword.evaluate(with: self)
    }
    
    var isValidAge: Bool {
        if let age = Int(self), age > 6 {
            return true
        }
        return false
    }
    
}
