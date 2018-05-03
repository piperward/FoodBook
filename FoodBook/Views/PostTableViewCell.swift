//
//  PostTableViewCell.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import AVFoundation
import NightNight

protocol PostTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    
    
    
    var delegate: PostTableViewCellDelegate?
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
        let ingredients = NSMutableAttributedString(string: (post?.ingredients)!)
        let caption = NSMutableAttributedString(string: (post?.caption)!)
        ingredients.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                       range: NSRange(location: 0, length: ingredients.string.count))
        caption.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                   range: NSRange(location: 0, length: caption.string.count))
        
        
        
        ingredientsLabel.attributedText = ingredients
        captionLabel.attributedText = caption
        if State.bold == true {
            ingredientsLabel.font = UIFont.boldSystemFont(ofSize: ingredientsLabel.font.pointSize)
            captionLabel.font = UIFont.boldSystemFont(ofSize: captionLabel.font.pointSize)
        } else {
            ingredientsLabel.font = UIFont.systemFont(ofSize: ingredientsLabel.font.pointSize)
            captionLabel.font = UIFont.systemFont(ofSize: captionLabel.font.pointSize)
        }
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
        
        //Nightmode
        self.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)

    }
    
    func setupUserInfo() {
        let name = NSMutableAttributedString(string: (user?.username)!)
        name.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                range: NSRange(location: 0, length: name.string.count))
        
        nameLabel.attributedText = name
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
        else {
            profileImageView.image = UIImage(named: "placeholderImg")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
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
    
    @objc func commentImageView_TouchUpInside() {
        print("commentImageView_TouchUpInside")
        if let id = post?.id {
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("11111")
        //profileImageView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
