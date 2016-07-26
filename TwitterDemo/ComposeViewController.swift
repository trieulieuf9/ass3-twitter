//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by trieulieuf9 on 7/25/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var composeTextView: UITextView!
    
    @IBOutlet weak var wordCountLabel: UILabel!
    
    override func viewDidLoad() {
        composeTextView.delegate = self
        composeTextView.becomeFirstResponder()
    }
    
    func textViewDidChange(composeTextView: UITextView) {
        let message = String(composeTextView.text.characters.count) + "/140 Characters"
        wordCountLabel.text = message
    }
    
    @IBAction func onPostButtonTouched(sender: AnyObject) {
        let message = composeTextView.text
        
        TwitterClient.shareInstance.composeTweet(message!, success: { (response:NSDictionary) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("ComposeViewDismissed", object: nil)
            
        }) { (error:NSError) in
            print(error.localizedDescription)
            // showing a pop up messsage here, say that "something wrong, post later"
            let alert = UIAlertController(title: "Something Wrong", message: "Come Back later", preferredStyle: UIAlertControllerStyle.Alert)
            
            let action = UIAlertAction(title: "Back To Home", style: .Default, handler: { (UIAlertAction) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
