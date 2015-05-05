//
//  ComposeTweetViewController.swift
//  TwitterClient
//
//  Created by Rohit Bhoompally on 5/3/15.
//  Copyright (c) 2015 Rohit Bhoompally. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Customize navigation bar */
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        /* Populate current user properties */
        let userImageUrl: NSURL = NSURL(string: User.currentUser!.profileImageUrl!)!
        userImage.setImageWithURL(userImageUrl)
        username.text = User.currentUser?.name
        screenname.text = "@" + User.currentUser!.screenName!
        
        tweetTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        textCount.text = ((140 - count(textView.text)) as NSNumber).stringValue
    }
    
    @IBAction func onClick(sender: AnyObject) {
        var status: String! = tweetTextView.text
        if (status == nil) {
            return
        }
        
        TwitterApiClient.sharedInstance.updateStatus(status, completion: { (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                println("Status update failed.")
            }
            
            if ( response != nil) {
                println("Status succesfully updated.")
                
            }
        })
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
