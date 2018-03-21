//
//  PhotoCollectionViewCell.swift
//  FoodBook
//
//  Created by Piper Ward on 3/21/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        photo.image = post?.photo
    }
}
