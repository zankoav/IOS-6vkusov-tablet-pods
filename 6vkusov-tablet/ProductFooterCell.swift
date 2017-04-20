//
//  ProductFooterCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/20/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class ProductFooterCell: UITableViewCell {

    @IBOutlet weak var add: UIButton!
    
    var product :Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    
    @IBAction func addPressed(_ sender: Any){
        print("add product")
        //Singleton.currentUser().getUser()?.getBasket().addProductFromRestaurantOrder(product: product, slug: slug)
    }

}
