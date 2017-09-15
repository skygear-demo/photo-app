//
//  FeedCell.swift
//  photo-app
//
//  Created by David Ng on 15/9/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
