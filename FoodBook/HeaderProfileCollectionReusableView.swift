//
//  HeaderProfileCollectionReusableView.swift
//  FoodBook
//
//  Created by Piper Ward on 3/21/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    //MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
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
        self.myPostsCountLabel.text = "\(postList.count)"
        self.followingCountLabel.text = "0"
        self.followersCountLabel.text = "0"
    }
    
    func clear() {
        self.nameLabel.text = ""
        self.myPostsCountLabel.text = ""
        self.followersCountLabel.text = ""
        self.followingCountLabel.text = ""
    }
}
