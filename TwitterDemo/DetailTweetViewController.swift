//
//  DetailTweetViewController.swift
//  TwitterDemo
//
//  Created by trieulieuf9 on 7/25/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

class DetailTweetViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
        
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!

    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    var tweet:Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyButton.setImage(UIImage(named: "reply-action_0"), forState: .Normal)
        retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like-action"), forState: .Normal)
        
        
        profileImageView.setImageWithURL((tweet!.user?.profileImageUrl)!)
        nameLabel.text = tweet!.user?.name
        screenNameLabel.text = "@" + (tweet!.user?.screenName)!
        tweetLabel.text = tweet!.text
        timeStampLabel.text = tweet!.createdAtString
        retweetCountLabel.text = String(tweet!.retweetCount)
        favoriteCountLabel.text = String(tweet!.favCount)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onReplyButtonTouch(sender: AnyObject) {
        // not really do anything here
    }
    
    // when the reply button touched
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let writeReplyVC = segue.destinationViewController as! WriteReplyViewController
        
        writeReplyVC.inReplyToStatusId = tweet?.id
    }
    
    
    @IBAction func onRetweetButtonTouch(sender: AnyObject) {
        TwitterClient.shareInstance.retweet((tweet?.id)!, success: { 
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
        }) { (error:NSError) in
            print("a little error")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onLikeButtonTouch(sender: AnyObject) {
        TwitterClient.shareInstance.like((tweet?.id)!, success: {
            self.likeButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
        }) { (error:NSError) in
            print("some Error")
        }
    }
    
    
}
