//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by trieulieuf9 on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    var tweet:Tweet?{
        didSet{
            profileImageView.setImageWithURL((tweet!.user?.profileImageUrl)!)
            nameLabel.text = tweet!.user!.name!
            screenNameLabel.text = "@" + tweet!.user!.screenName!
            tweetContentLabel.text = tweet!.text!
            timeStampLabel.text = tweet!.timeSinceCreated!
        }
    }
}
