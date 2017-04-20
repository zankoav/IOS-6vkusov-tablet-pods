//
//  SuggestTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/14/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class SuggestTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
