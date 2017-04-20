//
//  BasketViewCntroller.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/7/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class BasketViewCntroller: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    var basket = Singleton.currentUser().getUser()!.getBasket()
    var width = UIScreen.main.bounds.width
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chekoutView: UIView!
    
    @IBOutlet weak var totalPriceItems: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var bonusCount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var buttonOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Корзина"
        self.tableView.delegate = self
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = width/2
        self.buttonOrder.layer.masksToBounds = true
        self.buttonOrder.layer.cornerRadius = 5
        updateChekList()
    }

    @IBAction func chekOrder(_ sender: Any) {
        let chekOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOrderViewController")
        self.navigationController?.pushViewController(chekOutViewController!, animated: true)    }
    
    func updateChekList(){
        let priceFromItems = basket.getTotalPriceFromItems()
        totalPriceItems.text = priceFromItems.getTowNumberAfter()
        let price = basket.getTotalPrice()
        totalPrice.text = price.getTowNumberAfter()
        bonusCount.text = "\(basket.getTotalPoints())"
        let ready = basket.isBasketReady()
        buttonOrder.isEnabled = ready
        buttonOrder.backgroundColor = ready ? UIColor(netHex: 0x8FB327) : UIColor.lightGray
        if ready{
            buttonOrder.setTitle("ОФОРМИТЬ ЗАКАЗ", for: UIControlState.normal)
        }else{
            let price = basket.getMinimalPrice()
            buttonOrder.setTitle("Минимальная сумма заказа \(price.getTowNumberAfter()) руб.", for: UIControlState.normal)
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return basket.productItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product_item_cell") as! ProductItemTableViewCell
        
        cell.productTableVC = self
        cell.productItem = basket.productItems[indexPath.row]
        cell.name.text = basket.productItems[indexPath.row].name
        let variant = basket.productItems[indexPath.row].variant
        let price = variant.price * Float(basket.productItems[indexPath.row].count)
        cell.totalPrice.text = price.getTowNumberAfter()
        if let points = basket.productItems[indexPath.row].points{
            if points > 0 {
                cell.add.isHidden = true
                cell.minus.isHidden = true
                cell.count.isHidden = true
                cell.totalPrice.text = "\(points)"
                cell.totalPriceLable.text = " баллов"
                
            }
        }
        cell.count.text = "\(basket.productItems[indexPath.row].count)"
        
        var desc = ""
        
        if let size = variant.size {
            desc = size
        }
        
        if let width = variant.weigth {
            desc += " \(width)"
        }
        
        cell.width.text = desc

        
        cell.icon.sd_setImage(with: URL(string: basket.productItems[indexPath.row].icon), placeholderImage: UIImage(named:"avatar"))
        
        return cell
    }

}
