//
//  ViewController.swift
//  ej2
//
//  Created by Dana Neyra on 1/13/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad")
        getTwitterTimeline()
    }
    
    func getTwitterTimeline() {
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        print ("getTwitterTimeline")
        account.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) in
                if (granted) {
                    let accounts = account.accountsWithAccountType(accountType)
                    if (accounts.count > 0) {
                        let timelineURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: timelineURL, parameters: nil)
                        request.account = accounts.first as! ACAccount
                        request?.performRequestWithHandler { data, _, error in
                            if error == nil {
                                do {
                                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [[String : AnyObject]]
                                    let tweets = json.map{createTweet($0)}
                                    print(tweets)
                                    //generateTable(tweets)
                                }
                                catch {
                                    print("JSONSerializingError")
                                }
                                print("FEED!")
                            } else {
                                print("Error fetching timeline \(error)")
                            }
                        }
                } else {
                    // error handler
                    print("not granted")
                }
            }
        }
    }
    
}


struct Tweet {
    let text: String
    let createdAt: NSDate
    let pic: NSURL
}

func twitterDateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return formatter
}

func createTweet(JSON: [String : AnyObject], dateFormatter: NSDateFormatter = twitterDateFormatter()) -> Tweet {
    let text = JSON["text"] as! String
    let rawCreatedAt = JSON["created_at"] as! String
    let picURL = JSON["user"]!["profile_image_url"] as! NSURL
    let date = dateFormatter.dateFromString(rawCreatedAt)
    return Tweet(text: text, createdAt: date!, pic: picURL)
}

