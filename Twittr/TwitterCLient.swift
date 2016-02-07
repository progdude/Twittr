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
    
    class var sharedInstance: TwitterCLient {
        struct Static {
            static let instance = TwitterCLient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
}
