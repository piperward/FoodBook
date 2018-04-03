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
    var photo: UIImage?
    var photoUrl: String?
    let ref: DatabaseReference?
    
    init(caption: String, photo: UIImage?) {
        self.caption = caption
        self.photo = photo
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        caption = snapshotValue["caption"] as! String
        photoUrl = snapshotValue["photoUrl"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return ["caption": caption]
    }
}
