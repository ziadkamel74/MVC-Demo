//
//  UIViewController+ShowAlert.swift
//  TODOApp-MVC-Demo
//
//  Created by Ziad on 10/31/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
