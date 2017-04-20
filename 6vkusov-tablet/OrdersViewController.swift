//
//  BonusViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/14/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class OrdersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LoadJson {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var orders:[Order] = []
    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "История заказов"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JsonHelperLoad.init(url: REST_URL.SF_ORDERS.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject,"session":Singleton.currentUser().getUser()?.getProfile()!["session"] as AnyObject], act: self, sessionName: nil).startSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let request = obj {
            if let status = request["status"] as? String{
                if status == "successful"{
                    let image_path = REST_URL.SF_DOMAIN.rawValue + (request["image_path"] as! String)
                    self.orders = [Order]()
                    let ordersArray = request["orders"] as! [Dictionary<String,AnyObject>]
                    for order in ordersArray {
                        let rest_slug = order["restaurant_slug"] as! String
                        let rest_name = order["restaurant_name"] as! String
                        let rest_icon = order["restaurant_icon"] as? String
                        let total_price = order["total_price"] as! Float
                        let id = order["id"] as! Int

                        let comments_exists = order["comment_exists"] as! Bool
                        let created = order["created"] as! UnixTime
                        let foodArray = order["food"] as! [Dictionary<String,Any>]
                        
                        let orederObject = Order(status: comments_exists ? ORDER_STATUS.COMMENTS_OK : ORDER_STATUS.COMMENTS_NO , created: created, restaurantSlug: rest_slug, restaurantName: rest_name, restaurantUrlIcon: image_path + (rest_icon == nil ? "" : rest_icon!), products: foodArray, totalPrice: total_price,id: id)
                        self.orders.append(orederObject)
                    }
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders[section].products.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height/4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = TitleHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5))
        sectionView.index = section%2 == 0
        sectionView.order = orders[section]
        sectionView.totalPrice.text = "\(orders[section].totalPrice)"
        sectionView.dateOrder.text = orders[section].created
        let status = orders[section].status
        if status == ORDER_STATUS.COMMENTS_NO{
            sectionView.buttonComments.isHidden = false
        }
        sectionView.nameRest.text = orders[section].restaurantName
        sectionView.imageView.sd_setImage(with: URL(string: orders[section].restaurantUrlIcon), placeholderImage: UIImage(named:"checkBoxOn"))
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "order_cell") as! OrderTableViewCell
        cell.name.text = orders[indexPath.section].products[indexPath.row]["name"] as? String
        cell.count.text = "\(orders[indexPath.section].products[indexPath.row]["count"] as! Int)"
        return cell
    }
    
}
