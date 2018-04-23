//
//  CommentTableViewCell.swift
//  FoodBook
//
//  Created by Kyle McCarver on 4/22/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var delegate: CommentTableViewCellDelegate?
    var comment: Comment? {
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
        commentLabel.text = comment?.commentText
//        commentLabel.userHandleLinkTapHandler = {
//            label, handle, rang in
//            var mention = handle
//            mention = String(mention.characters.dropFirst())
//            Api.User.observeUserByUsername(username: mention.lowercased(), completion: { (user) in
//                self.delegate?.goToProfileUserVC(userId: user.id!)
//            })
//            
//        }
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            if let photoUrl = URL(string: photoUrlString) {
                let data = try? Data(contentsOf: photoUrl)
                if let imageData = data {
                    profileImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

