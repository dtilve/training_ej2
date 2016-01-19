//
//  tweetCellTableViewCell.swift
//  ej2
//
//  Created by Dana Tilve on 18/01/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit

class tweetCellTableViewCell: UITableViewCell {

    // MARK : Properties
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetPic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
