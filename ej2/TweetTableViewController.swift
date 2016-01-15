//
//  TweetTableViewCell.swift
//  ej2
//
//  Created by Dana Neyra on 1/14/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import UIKit

class tweetTableViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetPic: UIImageView!
   
    
    // Methods
    func fill ( tweets : [Tweet]){
        let filledUp = tweets.map(compose)
        print(filledUp)
    }
    
    func compose ( tweet : Tweet){
        self.tweetText.text = tweet.text
//        self.tweetDate.text = tweet.createdAt
    }
}