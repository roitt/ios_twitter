//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 5/3/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)

        makeTwitterTimelineCall(false)
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
    }
    
    func makeTwitterTimelineCall(isRefreshing: Bool) {
        TwitterApiClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        })
    }
    
    func onRefresh() {
        makeTwitterTimelineCall(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        tweetsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweetAtIndexPath: Tweet = tweets[indexPath.row]
        cell.username.text = tweetAtIndexPath.author?.name
        var screenName: String = "@"
        screenName += tweetAtIndexPath.author!.screenName!
        cell.userId.text = screenName
        cell.tweet.text = tweetAtIndexPath.text
        cell.timeStap.text = tweetAtIndexPath.userReadableDateString
        
        /* Set tweeter image */
        let profileImageUrl: NSURL? = NSURL(string: tweetAtIndexPath.author!.profileImageUrl!)
        if (profileImageUrl != nil) {
            var urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: profileImageUrl!)
            cell.userImage.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (request:NSURLRequest!, response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                if urlRequest != request {
                    cell.userImage.image = image
                } else {
                    UIView.transitionWithView(cell.userImage, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                        cell.userImage.image = image
                        }, completion: nil)
                }
                }) { (request:NSURLRequest!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tweetDetailViewController = segue.destinationViewController as? TweetDetailViewController
        if let tweetDetailViewController = tweetDetailViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tweetsTableView.indexPathForCell(cell)!
            let tweet = tweets[indexPath.row]
            tweetDetailViewController.tweet = tweet;
        }
    }
}
