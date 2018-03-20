//
//  PostTableViewCell.swift
//  FoodBook
//
//  Created by Kyle McCarver on 3/20/18.
//  Copyright © 2018 Team3. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
