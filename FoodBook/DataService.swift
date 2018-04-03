//
//  DataService.swift
//  FoodBook
//
//  Created by Piper Ward on 4/2/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    var BASE_REF = Database.database().reference()
    var USER_REF = Database.database().reference(withPath: "users")
    var POST_REF = Database.database().reference(withPath: "posts")
}
