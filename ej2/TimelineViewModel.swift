//
//  TableViewModel.swift
//  ej2
//
//  Created by Dana Neyra on 1/21/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Accounts

final class TimelineViewModel {
    
    private let _tweets: MutableProperty<[TweetViewModel]> = MutableProperty([])
    var tweets: AnyProperty<[TweetViewModel]>
    
    var count: Int {
        return tweets.value.count
    }
    
    let fetchTimeline = Action<AnyObject, [TweetViewModel], NSError> { _ in
        return createTweetProducer().map { tweets in tweets.map { TweetViewModel(tweet: $0) } }
            .observeOn(UIScheduler())
    }
    
    init() {
        tweets = AnyProperty(initialValue: [], producer: _tweets.producer.observeOn(UIScheduler()))
        _tweets <~ fetchTimeline.values
    }
    
    subscript(index: Int) -> TweetViewModel {
        return tweets.value[index]
    }
    
}

private typealias TweetProducer = SignalProducer<[Tweet], NSError>

private func createTweetProducer() -> TweetProducer {
    let accountService = AccountService()
    return accountService.accessTwitterAccount().flatMap(FlattenStrategy.Concat) { (account: ACAccount) -> TweetProducer in
        let twitterService = TwitterService(account: account)
        return twitterService.fetchTimeline()
    }
}