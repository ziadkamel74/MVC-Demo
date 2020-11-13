//
//  Task.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 10/31/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct TaskData: Codable {
    let description: String
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case id = "_id"
    }
}
