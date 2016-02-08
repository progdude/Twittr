//
//  TwitterCLient.swift
//  Twittr
//
//  Created by Archit Rathi on 2/7/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "FCmR18lDsHr50ZtrqS29fo8dF"
let twitterConsumerSecret = "9njt1ZTrgj3vWuP13v7C9csFuw6DkY6ROexH6fOQ2I3ZXl2u4U"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterCLient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterCLient {
        struct Static {
            static let instance = TwitterCLient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterCLient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterCLient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Error getting request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token")
            
            TwitterCLient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterCLient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("It worked!!!")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user:user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("It did not work")
                    self.loginCompletion?(user: nil, error: error)
                    
            })
            
            TwitterCLient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //                print("It worked!!!")
                //                print("user: \(response)")
                var tweets = Tweet.tweetswithArray(response as! [NSDictionary])
                
                for tweet in tweets {
                    print("text: \(tweet.text), created: \(tweet.createdAt)")
                }
                
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("It did not work")
                    self.loginCompletion?(user: nil, error: error)
                    
            })
            
            }) { (error: NSError!) -> Void in
                print("An error occurred")
                self.loginCompletion?(user: nil, error: error)
                
        }
        
    }
}
