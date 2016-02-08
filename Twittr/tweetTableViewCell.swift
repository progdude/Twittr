//
//  tweetTableViewCell.swift
//  Twittr
//
//  Created by Archit Rathi on 2/7/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit

class tweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var retweet: UILabel!
    @IBOutlet weak var favorites: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var im: UIImageView!

 
    var tweet: Tweet! {
        didSet {
            
            content.text = tweet.text!;
            
            name.text = tweet.user!.name
            username.text = "@\(tweet.user!.screenName!)"
            
        
            retweet.text = "\(tweet.retweetCount!) retweets";
            favorites.text = "\(tweet.favoriteCount!) favorites";
            

            im.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
