//
//  Post.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

class Post {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var ratio: CGFloat?
    var videoUrl: String?
    var ingredients: String?
}

extension Post {
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        post.ingredients = dict["ingredients"] as? String
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
}

/*public class Post {
    
    var caption: String
    var photoUrl: String
    var uid: String
    let ref: DatabaseReference
    
    // Create a post from a Firebase DataSnapshot to be displayed in the app
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        // Extract post data by key
        caption = snapshotValue["caption"] as! String
        photoUrl = snapshotValue["photoUrl"] as! String
        uid = snapshotValue["uid"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return ["caption": caption]
    }
}*/
