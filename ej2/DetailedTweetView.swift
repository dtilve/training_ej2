//
//  DetailedTweetView.swift
//  ej2
//
//  Created by Dana Neyra on 1/22/16.
//  Copyright © 2016 Dana. All rights reserved.
//


import UIKit
import Foundation
import ReactiveCocoa

class DetailedTweetView: UIViewController {
   
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var text: UITextView!


    func fillInWith(tweet: TweetViewModel){
        pic.image = nil
        date.text = tweet.createdAt
        text.attributedText = tweet.text
    }
}
