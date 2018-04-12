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
        // Download image from its Firebase Storage URL
        let url = URL(string: (post?.photoUrl)!)
        if let data = try? Data(contentsOf: url!) {
            photo.image = UIImage(data: data)!
        }
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
    }
    
    @objc func photo_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
}
