//
//  TodoCell.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 11/4/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK:- Static Properties
    static let identifier = "TodoCell"
    
    // MARK:- Public Functions
    class func nib() -> UINib {
        return UINib(nibName: "TodoCell", bundle: nil)
    }
    
    // MARK:- Internal Functions
    func configure(description: String) {
        descriptionLabel.text = description
    }
    
}
