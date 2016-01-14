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
                                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                                    let tweets = json.valueForKey("text") as! NSArray
                                    let dates = json.valueForKey("created_at") as! NSArray
                                    
                                    
                                        
                                    print(tweets)
                                    print(dates)
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

