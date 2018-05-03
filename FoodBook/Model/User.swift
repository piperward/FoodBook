//
//  User.swift
//  FoodBook
//
//  Created by Piper Ward on 3/21/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation

class User {
    // User information that is pulled from the database
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var bio: String?
    var isFollowing: Bool?
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        
        // Extract data by key
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        user.bio = dict["bio"] as? String
        return user
    }
}
