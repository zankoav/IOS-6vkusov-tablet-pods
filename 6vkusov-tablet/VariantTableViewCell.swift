//
//  VariantTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class VariantTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var minus: UIButton!
    
    var vc: ProductsTableViewController!
    var variant: Variant!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonAdded(_ sender: Any) {
        variant.addCount()
        count.text = "\(variant.count)"
        let priceStr = (Float(variant.count) * variant.price).getTowNumberAfter()
        price.text = priceStr
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        if variant.count > 0 {
            variant.minusCount()
            count.text = "\(variant.count)"
            let priceStr = (Float(variant.count) * variant.price).getTowNumberAfter()
            price.text = priceStr
        }
    }
    
}
