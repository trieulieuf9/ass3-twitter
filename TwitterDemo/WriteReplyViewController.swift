//
//  WriteReplyViewController.swift
//  TwitterDemo
//
//  Created by trieulieuf9 on 7/26/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class WriteReplyViewController: UIViewController {
    
    @IBOutlet weak var replyTextView: UITextView!
    
    var inReplyToStatusId:Int? = nil
    
    @IBAction func onReplyButtonTouch(sender: AnyObject) {
        let reply = replyTextView.text
        TwitterClient.shareInstance.reply(reply, statusId: inReplyToStatusId!, success: {
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error:NSError) in
            print("little error")
        }
    }

}
