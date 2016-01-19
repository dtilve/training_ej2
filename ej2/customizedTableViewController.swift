//
//  customizedTableViewController.swift
//  ej2
//
//  Created by Dana Tilve on 18/01/16.
//  Copyright © 2016 Dana. All rights reserved.
//

//import DateTools
import UIKit
import Foundation
import Accounts
import Social

class customizedTableViewController: UITableViewController {

    // MARK : Properties
    
    var tweets = Array<Tweet>()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        getTwitterTimeline()
        print("gotTwitterTimeLine")
        
    }
    
    func loadSampleTweets(){
        let now = NSDate.init()
        let url = NSURL(string: "https://pbs.twimg.com/profile_images/678757000289849344/qIGbpOUL.jpg")
        let sampleTweet = Tweet.init(text: "Hello World!", createdAt: now, pic: url!)
        
        tweets=[sampleTweet]
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
                                self.tweets = json.map{createTweet($0)} as Array<Tweet>
                                self.tableView.reloadData()
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! tweetCellTableViewCell
        let tweet = tweets[indexPath.row]

        cell.tweetDate.text = tweet.createdAt.description
        cell.tweetText.text = tweet.text
       // let urlToData = NSData(contentsOfURL: tweet.pic)
       // cell.tweetPic.image = UIImage.init(data: urlToData!)
        
        return cell
    }
    

}

struct Tweet {
    let text: String
    var createdAt: NSDate
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
    let picURL = NSURL(string: JSON["user"]!["profile_image_url"] as! String)
    let date = dateFormatter.dateFromString(rawCreatedAt)
    return Tweet(text: text, createdAt: date!, pic: picURL!)
}
