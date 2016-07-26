//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class HomeViewController: UIViewController {
    
    var arrayOfTweets = [Tweet]()
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull to refresh
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // insert refreshControl into tableView 
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.shareInstance.homeTimeline({ (tweets:[Tweet]) in
            self.arrayOfTweets = tweets
            self.tableView.reloadData()
        }) { (error:NSError) in
            print(error)
        }
    }
    
    @IBAction func onLogoutClicked(sender: AnyObject) {
        TwitterClient.shareInstance.logout()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    
    func refreshControlAction(){
        TwitterClient.shareInstance.homeTimeline({ (tweets:[Tweet]) in
            self.arrayOfTweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error:NSError) in
            print(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier! == "composeSegue"{
        NSNotificationCenter.defaultCenter().addObserverForName("ComposeViewDismissed", object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) in
                
                TwitterClient.shareInstance.homeTimeline({ (tweets:[Tweet]) in
                    self.arrayOfTweets = tweets
                    self.tableView.reloadData()
                    
                }) { (error:NSError) in
                    print(error)
                }
            }
            
        } else if segue.identifier! == "detailSegue" {
            // detailTweetViewController segue
            let indexPath = tableView.indexPathForSelectedRow
            let detailTweetVC = segue.destinationViewController as! DetailTweetViewController
            detailTweetVC.tweet = arrayOfTweets[indexPath!.row]
        }
        
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        cell.tweet = arrayOfTweets[indexPath.row]
        
        return cell
    }
}




