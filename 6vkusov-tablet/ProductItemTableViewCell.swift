//
//  ProductItemTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/6/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class ProductItemTableViewCell: UITableViewCell {

    
    var productItem: ProductItem!
    let basket = Singleton.currentUser().getUser()?.getBasket()
    var productTableVC: BasketViewCntroller!
    
    @IBOutlet weak var remove: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var width: UILabel!

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalPriceLable: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var minus: UIButton!
    
    private var isLast = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        remove.layer.masksToBounds = true
        remove.layer.cornerRadius = remove.bounds.width/2
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 5
        // Configure the view for the selected state
    }

    @IBAction func buttonAdded(_ sender: Any) {
        basket?.addProductItemFromBasket(productItem: productItem)
        totalPrice.text = "\(Float(productItem.count) * productItem.variant.price)"
        count.text = "\(productItem.count)"
        productTableVC.updateChekList()
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        if productItem.count == 1 {
            isLast = true
        }
        basket?.minusProductItemFromBasket(id: productItem.variant.id)
        totalPrice.text = "\(Float(productItem.count) * productItem.variant.price)"
        count.text = "\(productItem.count)"
        productTableVC.updateChekList()
        if isLast {
            productTableVC.tableView.reloadData()
        }
        
    }
    
    @IBAction func removePressed(_ sender: Any) {
        basket?.removeProductItem(productItem: productItem)
        productTableVC.tableView.reloadData()
        productTableVC.updateChekList()
    }
}
