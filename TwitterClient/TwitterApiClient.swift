//
//  TwitterApiClient.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 4/29/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

let twitterConsumerKey = "mzHdyBvERJGiCCuIvjp29ZyyH"
let twitterConsumerSecret = "zKh9IAPMwtNvaP3pV2JEFulF0L8mYp0GiVy3lMUKB8ucjELG7c"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterApiClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterApiClient {
        struct Static {
            static let instance = TwitterApiClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and open URL in mobile browser
        TwitterApiClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterApiClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Got request token: \(requestToken)")
                var authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authUrl!)
            },
            failure: { (error: NSError!) -> Void in
                println("Error getting request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            println(response)
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweets: nil, error: error)
        })
    }
    
    func updateStatus(text: String, completion: (AnyObject?, NSError?) -> Void) {
        let params = [
            "status": text
        ]
        
        POST("1.1/statuses/update.json", parameters: params, success: { (request, response) in
                completion(response, nil)
            },
            failure: { (request, error) in
                completion(nil, error)
        })
    }
    
    func retweetWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("/1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(tweet: nil, error: error)
        }
    }
    
    func favoriteWithCompletion(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var params = ["id": tweetId]
        
        POST("/1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(tweet: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Access token: \(accessToken)")
            TwitterApiClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterApiClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //                 println("User: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("User: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting user creds: \(error)")
                self.loginCompletion?(user: nil, error: error)
            })
        })
        {(error: NSError!) -> Void in
            println("Error whilte fetching token: \(error)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
