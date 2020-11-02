//
//  LoginResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let token: String
    let user: UserData

    enum CodingKeys: String, CodingKey {
        case token, user
    }
}
