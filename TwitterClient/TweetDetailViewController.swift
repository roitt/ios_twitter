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
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet weak var retweetsCount: UILabel!
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
        
        favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Selected)
        retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Selected)
        
        retweetsCount.text = (tweet!.retweetCount! as NSNumber).stringValue + " RETWEETS"
        favoritesCount.text = (tweet!.favoriteCount! as NSNumber).stringValue + " FAVORITES"
        
        if (tweet.favorited == true) {
            highlightFavorites()
        }
        
        if tweet.retweeted == true {
            highlightRetweets()
        }
    }
    
    func highlightFavorites() {
        favoriteButton.selected = true
        favoritesCount.textColor = UIColor(red: 90.0/255.0, green: 120/255.0, blue: 60/255.0, alpha: 1.0)
    }
    
    func highlightRetweets() {
        retweetButton.selected = true
        retweetsCount.textColor = UIColor(red: 90.0/255.0, green: 120/255.0, blue: 60/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterApiClient.sharedInstance.retweetWithCompletion(tweet!.id!, completion: { (newTweet, error) -> () in
            if error == nil {
                self.tweet!.retweeted = true
                self.retweetsCount.text = "\(self.tweet!.retweetCount! + 1)" + " RETWEETS"
                self.highlightRetweets()
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
    TwitterApiClient.sharedInstance.favoriteWithCompletion(tweet!.id!, completion: { (newTweet, error) -> () in
            if error == nil {
                self.tweet!.favorited = true
                self.favoritesCount.text = "\(self.tweet!.favoriteCount! + 1)" + " FAVORITES"
                self.highlightFavorites()
            }
        })
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
