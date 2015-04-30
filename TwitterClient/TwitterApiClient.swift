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

    class var sharedInstance: TwitterApiClient {
        struct Static {
            static let instance = TwitterApiClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
