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
    static let toDoListVC = "ToDoListVC"
    static let profileVC = "ProfileVC"
    static let profileTableVC = "ProfileTableVC"
}

// Urls
struct URLs {
    static let base = "https://api-nodejs-todolist.herokuapp.com"
    static let login = base + "/user/login"
    static let register = base + "/user/register"
    static let logout = base + "/user/logout"
    static let userData = base + "/user/me"
    static let baseTask = base + "/task"
    static let userAvatar = base + "/user/me/avatar"
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
    static let avatar = "avatar"
}

// FormData
struct FormData {
    static let name = "avatar"
    static let fileName = "/home/ali/Mine/c/nodejs-blog/public/img/blog-header.jpg"
    static let mimeType = "blog-header.jpg"
}

// UserDefaultsKeys
struct UserDefaultsKeys {
    static let token = "UDKToken"
}

// Cells
struct Cells {
    static let toDoCell = "ToDoCell"
}
