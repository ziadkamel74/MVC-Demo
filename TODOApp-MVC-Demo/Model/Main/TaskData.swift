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
    
    init(description: String, id: String?) {
        self.description = description
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case description
        case id = "_id"
    }
}
