//
//  Comment.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/22/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation
class Comment {
    // Properties to be pulled from the database and shown in the comment view controller
    var commentText: String?
    var uid: String?
}

extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        
        // Extract data by key
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
