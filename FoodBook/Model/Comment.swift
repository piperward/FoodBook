//
//  Comment.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/22/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import Foundation
class Comment {
    var commentText: String?
    var uid: String?
}

extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
