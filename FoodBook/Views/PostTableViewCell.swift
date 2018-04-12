//
//  PostTableViewCell.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import AVFoundation

protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    
    
    
    var delegate: HomeTableViewCellDelegate?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        if let ratio = post?.ratio {
            heightConstraintPhoto.constant = UIScreen.main.bounds.width / ratio
            layoutIfNeeded()
            
        }
        if let photoUrlString = post?.photoUrl {
            if let photoUrl = URL(string: photoUrlString) {
                let data = try? Data(contentsOf: photoUrl)
                if let imageData = data {
                    postImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        self.updateLike(post: self.post!)
    }
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: UIControlState.normal)
        } else {
            likeCountButton.setTitle("Be the first like this", for: UIControlState.normal)
        }
        
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            if let photoUrl = URL(string: photoUrlString) {
                let data = try? Data(contentsOf: photoUrl)
                if let imageData = data {
                    profileImageView.image = UIImage(data: imageData)
                }
                else {
                    profileImageView.image = UIImage(named: "placeholderImg")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    @objc func likeImageView_TouchUpInside() {
        //TODO implement likes
//        Api.incrementLikes(postId: post!.id!, onSucess: { (post) in
//            self.updateLike(post: post)
//            self.post?.likes = post.likes
//            self.post?.isLiked = post.isLiked
//            self.post?.likeCount = post.likeCount
//        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("11111")
        profileImageView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
