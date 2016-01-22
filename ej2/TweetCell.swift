//
//  tweetCellTableViewCell.swift
//  ej2
//
//  Created by Dana Tilve on 18/01/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit
import ReactiveCocoa

final class TweetCell: UITableViewCell {

    // MARK : Properties

    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var tweetPic: UIImageView!
    
    private var _fetchImageDisposable: Disposable? = Optional.None

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        _fetchImageDisposable?.dispose()
        _fetchImageDisposable = Optional.None
    }
    
    func bind(tweet: TweetViewModel) {
        tweetDate.text = tweet.createdAt
        tweetText.attributedText = tweet.text
        tweetPic.image = nil
        _fetchImageDisposable = tweet.fetchImage()
            .startWithNext { self.tweetPic.image = $0 }
    }
    
}
