//
//  Post.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

public class Post {
    
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
}
