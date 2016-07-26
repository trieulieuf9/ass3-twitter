//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBAction func onLogin(sender: UIButton) {
        
        TwitterClient.shareInstance.login({
            // called from self.loginSuccess? from TwitterClient
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }) { (error:NSError) in
            print("little error")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
