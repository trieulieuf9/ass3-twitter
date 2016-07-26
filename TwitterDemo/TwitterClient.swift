//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by trieulieuf9 on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    // TODO: Get request token, redirect to authURL, convert requestToken -> accessToken
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "jSZV1IOHAnWStyzR6fcM2Kj2a", consumerSecret: "L5Njf5s1SxOdg39DySVtgRxQHuubdtjbuDY5Pt9RGsdmLAWsMt")
    
    
    
    func composeTweet(status:String, success: (NSDictionary) -> (), failure: (NSError) -> ()){
        let para: NSDictionary = ["status": status]
        
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: para, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            // do somethings when success
            let dic = response as! NSDictionary
            success(dic)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
//     reply action
    func reply(status:String, statusId:Int, success: () -> (), failure: (NSError) -> ()){
        let para: NSDictionary = ["status": status, "in_reply_to_status_id":statusId]
        
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: para, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    // retweet action
    func retweet(tweetId:Int, success: () -> (), failure: (NSError) -> ()){
        let para: NSDictionary = ["id": tweetId]
        let url = "https://api.twitter.com/1.1/statuses/retweet/" + String(tweetId) + ".json"
        
        POST(url, parameters: para, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            // do somethings when success
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    // like action
    func like(tweetId:Int, success: () -> (), failure: (NSError) -> ()){
        let para: NSDictionary = ["id": tweetId]
        
        POST("https://api.twitter.com/1.1/favorites/create.json", parameters: para, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            // do somethings when success
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        // get home timeline
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        // get my account
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            print("\(user.name!)")
            print("\(user.screenName!)")
            print("\(user.tagline!)")
            print("\(user.profileImageUrl)")
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
                failure(error)
        })
    }
    // logged in, go to homeview
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            
            self.currentAccount({ (user:User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    
    var loginSuccess : (() -> ())?
    var loginFailure : ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shareInstance.fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "trieulieuf9://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            TwitterClient.shareInstance.deauthorize()
            
            // TODO: redirect to authrization url
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
    }
}
