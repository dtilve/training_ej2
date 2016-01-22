//
//  TweetViewModel.swift
//  ej2
//
//  Created by Dana Neyra on 1/21/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class TweetViewModel {
    
    private let _tweet: Tweet
    private var _avatar: UIImage? = Optional.None
    private let _URLSession: NSURLSession
    
    let createdAt: String
    let text: NSAttributedString
    
    init(tweet: Tweet, URLSession: NSURLSession = NSURLSession.sharedSession()) {
        text = formatTweetText(tweet.text)
        createdAt = tweet.createdAt.timeAgoSinceNow()
        _tweet = tweet
        _URLSession = URLSession
    }
    
    func fetchImage() -> SignalProducer<UIImage, NSError> {
        if let avatar = _avatar {
            return SignalProducer(value: avatar)
        }
        return _URLSession.rac_dataWithRequest(NSURLRequest(URL: _tweet.pic))
            .map { UIImage(data: $0.0)! }
            .on(next: { self._avatar = $0 })
            .observeOn(UIScheduler())
    }
}

private func chopOffNonAlphaNumericCharacters(text:String) -> String {
    let nonAlphaNumericCharacters = NSCharacterSet.alphanumericCharacterSet().invertedSet
    let characterArray = text.componentsSeparatedByCharactersInSet(nonAlphaNumericCharacters)
    return characterArray[0]
}

private func formatTweetText(text: String) -> NSAttributedString {
    
    let nsText:NSString = text
    let words:[NSString] = nsText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(11.0)]
    
    let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
    
    var bookmark = 0
    for word in words{
        if word.hasPrefix("@"){
            var stringifiedWord = word as String
            let prefix = Array(stringifiedWord.characters)[0]
            stringifiedWord = chopOffNonAlphaNumericCharacters(String(stringifiedWord.characters.dropFirst()))
            
            let prefixedWord = "\(prefix)\(stringifiedWord)"
            let remainingRange = NSRange(location: bookmark, length: (nsText.length - bookmark))
            let matchRange:NSRange = nsText.rangeOfString(prefixedWord, options: NSStringCompareOptions.LiteralSearch, range:remainingRange)
            
            if let _ = stringifiedWord.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()){
                attrString.addAttribute(NSLinkAttributeName, value: "https://twitter.com/"+stringifiedWord, range: matchRange)
            }
            
            bookmark += word.length + 1
        }
    }
    return attrString
}