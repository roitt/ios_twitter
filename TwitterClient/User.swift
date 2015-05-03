//
//  User.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 4/30/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

let currentUserKey = "user.currentuser"
let userDidLoginNotification = "user.userdidloginnotification"
let userDidLogoutNotification = "user.userdidlogoutnotification"

var _currentUser: User?
class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline : String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterApiClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser;
        }
        set (user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
