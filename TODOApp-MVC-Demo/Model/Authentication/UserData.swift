//
//  UserData.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    var id: String?
    var name, email: String
    var password: String?
    var age: Int
    
    init(name: String, email: String, age: Int, password: String) {
        self.name = name
        self.email = email
        self.age = age
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case age, name, email, password
        case id = "_id"
    }
}
