//
//  tweetText.swift
//  ej2
//
//  Created by Dana Neyra on 1/19/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit

extension UITextView {
    
    func chopOffNonAlphaNumericCharacters(text:String) -> String {
        let nonAlphaNumericCharacters = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let characterArray = text.componentsSeparatedByCharactersInSet(nonAlphaNumericCharacters)
        return characterArray[0]
    }
    
    func resolve () {
        
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
        self.attributedText = attrString
    }
}