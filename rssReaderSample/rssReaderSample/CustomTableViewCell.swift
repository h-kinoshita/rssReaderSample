//
//  CustomTableViewCell.swift
//  rssReaderSample
//
//  Created by h.kinoshita on 2016/04/02.
//  Copyright © 2016年 mebro Inc. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: -Overrides-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -Outlets-
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var title: UILabel!
}
