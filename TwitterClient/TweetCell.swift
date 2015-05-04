//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 5/3/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var timeStap: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Make the corners rounded
        userImage.layer.cornerRadius = 4
        
        // Clip the bitmap
        userImage.clipsToBounds = true
        
        // Fix the bug where the label doesn't wrap to next line
        tweet.preferredMaxLayoutWidth = tweet.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweet.preferredMaxLayoutWidth = tweet.frame.size.width
    }
}
