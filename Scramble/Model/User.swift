//
//  Users.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 21/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

class User: NSObject {
    
    @objc var ownerID: String?
    @objc var username: String?
    @objc var email: String?
    @objc var profileUrl: String?
    @objc var id: String?
    @objc var friends: [String: Any]?
    
    @objc var isFollowed: Bool {
        
        set {
            UserDefaults.standard.set(newValue, forKey: "\(username ?? "")")
        }
        
        get {
            return UserDefaults.standard.bool(forKey: "\(username ?? "")")
        }
        
    }
    
}
