//
//  Model.swift
//  ej2
//
//  Created by Dana Neyra on 1/20/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation

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

