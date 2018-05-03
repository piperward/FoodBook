//
//  PeopleTableViewCell.swift
//  FoodBook
//
//  Created by Piper Ward on 4/3/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit
import NightNight

protocol PeopleTableViewCellDelegate {
    func goToProfilVC(userId: String)
}

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: PeopleTableViewCellDelegate?
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        //Creating attributed strings for nightmode
        let name = NSMutableAttributedString(string: (user?.username)!)
        name.setMixedAttributes([NNForegroundColorAttributeName:
            MixedColor(normal: 0x000000, night: 0xfafafa)],
                                                  range: NSRange(location: 0, length: name.string.count))
        nameLabel.attributedText = name
        
        //Nightmode setup
        self.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x222222)
        
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            let data = try? Data(contentsOf: photoUrl!)
            if let imageData = data {
                self.profileImage.image = UIImage(data: imageData)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfilVC(userId: id)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
