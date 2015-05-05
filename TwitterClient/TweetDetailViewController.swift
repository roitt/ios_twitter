//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 5/4/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet : Tweet!

    @IBOutlet weak var tweetDateTime: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweeterScreenName: UILabel!
    @IBOutlet weak var tweeterName: UILabel!
    @IBOutlet weak var tweeterImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Customize navigation bar */
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        /* Populate detail view */
        tweeterImage.setImageWithURL(NSURL(string: tweet.author!.profileImageUrl!))
        tweeterName.text = tweet.author?.name
        tweeterScreenName.text = tweet.author?.screenName
        tweetText.text = tweet.text
        
        /* Format the date as needed */
        let createdAt: NSDate = tweet.createdAt!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "H:mm a MMM d, yy"
        tweetDateTime.text = dateFormatter.stringFromDate(createdAt)
        
        if (tweet.favorited == true) {
            favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        
        if tweet.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
    }

    @IBAction func onRetweet(sender: AnyObject) {
    }
    @IBAction func onReply(sender: AnyObject) {
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
