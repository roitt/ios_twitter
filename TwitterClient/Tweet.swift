//
//  Tweet.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 4/30/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var author: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var userReadableDateString: String?
    var favorited: Bool?
    var retweeted: Bool?
    var favoriteCount: Int?
    var retweetCount: Int?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter();
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        /* Create user readable date string */
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yy"
        userReadableDateString = dateFormatter.stringFromDate(createdAt!)
        
        let ftd: Int = (dictionary["favorited"] as? Int)!
        if ftd == 0 {
            favorited = false
        } else {
            favorited = true
        }
        
        let rtd: Int = (dictionary["retweeted"] as? Int)!
        if  rtd == 0 {
            retweeted = false
        } else {
            retweeted = true
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
