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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterApiClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        })
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweetAtIndexPath: Tweet = tweets[indexPath.row]
        cell.username.text = tweetAtIndexPath.author?.name
        cell.userId.text = tweetAtIndexPath.author?.screenName
        cell.tweet.text = tweetAtIndexPath.text
        cell.timeStap.text = tweetAtIndexPath.createdAtString
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
