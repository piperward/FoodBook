//
//  HeaderProfileCollectionReusableView.swift
//  FoodBook
//
//  Created by Piper Ward on 3/21/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import Firebase

protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    //MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clear()
    }
    
    func updateView() {
        self.nameLabel.text = user!.username
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            let data = try? Data(contentsOf: photoUrl!)
            if let imageData = data {
                self.profileImage.image = UIImage(data: imageData)
            }
        }
        
        Api.fetchCountMyPosts(userId: user!.id!) { (count) in
            self.myPostsCountLabel.text = "\(count)"
        }
        
        Api.fetchCountFollowing(userId: user!.id!) { (count) in
            self.followingCountLabel.text = "\(count)"
        }
        
        Api.fetchCountFollowers(userId: user!.id!) { (count) in
            self.followersCountLabel.text = "\(count)"
        }
        
//        updateStateFollowButton()
    }
    
    func clear() {
        self.nameLabel.text = ""
        self.myPostsCountLabel.text = ""
        self.followersCountLabel.text = ""
        self.followingCountLabel.text = ""
    }
//    TODO implement followers
    
//    func updateStateFollowButton() {
//        if user!.isFollowing! {
//            configureUnFollowButton()
//        } else {
//            configureFollowButton()
//        }
//    }
    
//    func configureUnFollowButton() {
//        followButton.layer.borderWidth = 1
//        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
//        followButton.layer.cornerRadius = 5
//        followButton.clipsToBounds = true
//
//        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
//        followButton.backgroundColor = UIColor.clear
//        followButton.setTitle("Following", for: UIControlState.normal)
//        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
//    }
//
//
//    func followAction() {
//        if user!.isFollowing! == false {
//            Api.Follow.followAction(withUser: user!.id!)
//            configureUnFollowButton()
//            user!.isFollowing! = true
//            delegate?.updateFollowButton(forUser: user!)
//        }
//    }
//
//    func unFollowAction() {
//        if user!.isFollowing! == true {
//            Api.Follow.unFollowAction(withUser: user!.id!)
//            configureFollowButton()
//            user!.isFollowing! = false
//            delegate?.updateFollowButton(forUser: user!)
//        }
//    }
}
