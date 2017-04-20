//
//  PromoTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class PromoTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bonus: UILabel!
    @IBOutlet weak var button: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("add promo")
    }

}
