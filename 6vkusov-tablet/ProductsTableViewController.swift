//
//  ProductsTableViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SCLAlertView

class ProductsTableViewController: UITableViewController, BasketViewDelegate, ReloadFreeFoodTableView  {

    var titleCat: String!
    var restaurant: Restaurant!
    var products = [Product]()
    var alert: SCLAlertView!
    var isFreeFood: Bool!
    
    private var button:UIBarButtonItem?
    private var label:UILabel!
    var width = UIScreen.main.bounds.width
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.currentUser().getUser()?.getBasket().initBasketFormServerForRegisterUser()
        Singleton.currentUser().getUser()?.getBasket().delegate = self
        Singleton.currentUser().getUser()?.getBasket().delegateReloadData = self
        let count = Singleton.currentUser().getUser()?.getBasket().getTotalCount()
        label.isHidden = count! > 0 ? false : true
        label.text = "\(count!)"
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleCat
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = width/2
        
        let containView = UIView(frame: CGRect(x:0, y:0,width:70, height:40))
        label = UILabel(frame: CGRect(x:40, y:5, width:20, height:20))
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(netHex: 0x8FB327)
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 9)
        label.layer.cornerRadius = label.bounds.height/2
        label.textAlignment = NSTextAlignment.center
        containView.addSubview(label)
        let imageButton = UIButton(frame: CGRect(x:0, y:5, width:70, height:30))
        imageButton.addTarget(self, action: #selector(basketOpen), for: UIControlEvents.touchUpInside)
        imageButton.setImage(UIImage(named: "shopping-cart"), for: UIControlState.normal)
        imageButton.contentMode = UIViewContentMode.scaleAspectFill
        containView.addSubview(imageButton)
        containView.addSubview(label)
        button = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func updateBasket(count: Int) {
        label.isHidden = count > 0 ? false : true
        label.text = "\(count)"
    }
    
    func showaAlert(product: Product, slug: String) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true,
            hideWhenBackgroundViewIsTapped:true
        )
        
        alert = SCLAlertView(appearance: appearance)
        alert.addButton("Да"){
            Singleton.currentUser().getUser()?.getBasket().resetBasket(product: product, slug: slug)
        }
        alert.showWarning("Внимание!",subTitle: "В Вашей корзине присутствуют товары из другого ресторана. Очистить корзину ?", closeButtonTitle:"Отмена")
        
    }

    func basketOpen(){
        if (Singleton.currentUser().getUser()?.getBasket().productItems.count)! > 0{
            let basketViewController = self.storyboard?.instantiateViewController(withIdentifier: "BasketViewCntroller")
            self.navigationController?.pushViewController(basketViewController!, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFreeFood {
            return 0
        }else{
            return products[section].variants.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product_cell") as! VariantTableViewCell
        let variant = products[indexPath.section].variants[indexPath.row]
        cell.variant = products[indexPath.section].variants[indexPath.row]
        cell.vc = self
        
        let price = Float(variant.count)*variant.price
        print("\(price)  - \(price.getTowNumberAfter())")
        cell.price.text = variant.count == 0 ? variant.price.getTowNumberAfter() : price.getTowNumberAfter()
        
        var desc = ""
        if let size = variant.size {
            desc = size
        }
        if let width = variant.weigth {
            desc += " \(width)"
        }
        cell.desc.text = desc
        cell.count.text = "\(variant.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ProductHeaderViewCell
        cell.name.text = products[section].name
        cell.desc.text = products[section].description
        cell.icon.sd_setImage(with: URL(string: products[section].icon), placeholderImage: UIImage(named:"avatar"))
        return cell.contentView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = FooterProductView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            view.product = products[section]
            view.slug = restaurant.slug
            view.isFreeFood = isFreeFood
            if isFreeFood {
                view.points.text = "\(products[section].points!) баллов"
                if Singleton.currentUser().getUser()?.getStatus() == STATUS.GENERAL {
                    view.button.backgroundColor =  UIColor.lightGray
                    view.button.setTitle("Зарегистрируйтесь", for: UIControlState.normal)
                }else{
                    if (Singleton.currentUser().getUser()?.getBasket().isFreeFoodExist)!  {
                        view.button.backgroundColor =  UIColor.lightGray
                        view.button.setTitle("Продукт в корзине", for: UIControlState.normal)
                    }
                }
            }
            view.points.isHidden = !self.isFreeFood
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
    
}
