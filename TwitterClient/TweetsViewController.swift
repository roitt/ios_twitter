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
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.username.text = "Rohit Bhoompally"
        cell.userId.text = "@RohitBhoompally"
        cell.tweet.text = "This is a tweet yo! This is a tweet yo! This is a tweet yo!"
        cell.timeStap.text = "12 04 24"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
//        if tweets != nil {
//            return tweets.count
//        } else {
//            return 0
//        }
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
