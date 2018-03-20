//
//  Post.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/19/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

public class Post {
    
    var caption: String
    var photo: UIImage?
    
    init(caption: String, photo: UIImage?) {
        self.caption = caption
        self.photo = photo
    }
}
