//
//  TwitterService.swift
//  ej2
//
//  Created by Dana Neyra on 1/20/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Accounts
import Social
import Result

private typealias JSON = [[String : AnyObject]]

protocol TwitterServiceType {
    
    func fetchTimeline() -> SignalProducer<[Tweet], NSError>
    
}

final class TwitterService: TwitterServiceType {
    
    private var _account: ACAccount
    private let _timelineURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
    
    init(account: ACAccount) {
        _account = account
    }
    
    func fetchTimeline() -> SignalProducer<[Tweet], NSError> {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: _timelineURL, parameters: nil)
        request.account = _account
        return request.performRequest()
            .flatMap(.Latest) { data, _ in SignalProducer.attempt { parseJSON(data) } }
            .map { $0.map { createTweet($0) } }
        }

}

private extension SLRequest {
    
    func performRequest() -> SignalProducer<(NSData, NSHTTPURLResponse), NSError> {
        return SignalProducer { observable, disposable in
            self.performRequestWithHandler { data, response, error in
                if error == nil {
                    observable.sendNext((data, response))
                    observable.sendCompleted()
                } else {
                    observable.sendFailed(error)
                }
            }
        }
    }
}

private func parseJSON(data: NSData) -> Result<JSON, NSError> {
    let parse: () throws -> JSON = { try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! JSON }
    return Result(attempt: parse)
}

private func createTweet(JSON: [String : AnyObject], dateFormatter: NSDateFormatter = twitterDateFormatter()) -> Tweet {
    
    // Text
    let text = JSON["text"] as! String
    
    // Date
    let rawCreatedAt = JSON["created_at"] as! String
    let date = dateFormatter.dateFromString(rawCreatedAt)
    
    // Image
    let picURL = NSURL(string: JSON["user"]!["profile_image_url"] as! String)
    
    return Tweet(text: text, createdAt: date!, pic: picURL!)

}


