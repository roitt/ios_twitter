//
//  ViewController.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 4/29/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
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
            }
        )
    }
}

