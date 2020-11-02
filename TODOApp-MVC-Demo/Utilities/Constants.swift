//
//  Constants.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation


// Storyboards
struct Storyboards {
    static let authentication = "Authentication"
    static let main = "Main"
}

// View Controllers
struct ViewControllers {
    static let signUpVC = "SignUpVC"
    static let signInVC = "SignInVC"
    static let todoListVC = "TodoListVC"
    static let profileVC = "ProfileVC"
}

// Urls
struct URLs {
    static let baseAuth = "https://api-nodejs-todolist.herokuapp.com/user"
    static let login = baseAuth + "/login"
    static let register = baseAuth + "/register"
    static let logout = baseAuth + "/logout"
    static let userData = baseAuth + "/me"
    static let baseTask = "https://api-nodejs-todolist.herokuapp.com/task"
}

// Header Keys
struct HeaderKeys {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

// Header Values
struct HeaderValues {
    static let appJSON = "application/json"
    static let bearer = "Bearer "
}

// Parameter Keys
struct ParameterKeys {
    static let name = "name"
    static let email = "email"
    static let password = "password"
    static let age = "age"
    static let description = "description"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
}

struct Cells {
    static let todoCell = "TodoCell"
    static let profileCell = "ProfileCell"
}
