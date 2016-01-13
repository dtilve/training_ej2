//
//  ViewController.swift
//  ej2
//
//  Created by Dana Neyra on 1/13/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit
import Accounts
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        func getTwitterTimeline() {
            let account = ACAccountStore()
            let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

            account.requestAccessToAccountsWithType(accountType, options: nil,
                completion: { (granted, error) in
                    if (granted)
                    {
                        let arrayOfAccount: NSArray = account.accountsWithAccountType(accountType)
                        
                        if (arrayOfAccount.count > 0)
                        {
                          //  let twitterAccount = arrayOfAccount.lastObject as! ACAccount

                            Alamofire.request(.GET, "https://twitter.com/dmtilve")
                                .responseJSON { response in
                                    print(response.data)
                                    (response.data?.valueForKey("text") as! [NSDictionary])
                                 }
                         
                            
                        }
    
                    }
                    else
                    {
                    // error handler
                    }
                }
        ) }

    }
}

