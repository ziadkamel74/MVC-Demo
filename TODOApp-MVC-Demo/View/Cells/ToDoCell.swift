//
//  TodoCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 11/4/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK:- Internal Functions
    func configure(description: String) {
        descriptionLabel.text = description
    }
    
}
