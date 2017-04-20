//
//  CommentCell.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 20/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textCommnet: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var like: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = icon.bounds.width/2
//        icon.layer.borderWidth = 1.0
//        icon.layer.borderColor = UIColor.lightGray.cgColor
        // Configure the view for the selected state
    }


}
