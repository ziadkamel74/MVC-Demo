//
//  UserDefaultsManager.swift
//  TODOApp-MVC-Demo
//
//  Created by IDEAcademy on 10/27/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    // MARK:- Singleton
    private static let sharedInstance = UserDefaultsManager()
    
    class func shared() -> UserDefaultsManager {
        return UserDefaultsManager.sharedInstance
    }
    
    // MARK:- Properties
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.token)
        }
        get {
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.token) != nil else {
                return nil
            }
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.token)!
        }
    }
}
