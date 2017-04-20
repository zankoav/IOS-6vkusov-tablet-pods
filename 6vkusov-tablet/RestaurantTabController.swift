//
//  RestaurantViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantTabController: UITabBarController, BasketViewDelegate {

    private var button:UIBarButtonItem?
    private var label:UILabel!
    var restaurant:Restaurant!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.currentUser().getUser()?.getBasket().delegate = self
        Singleton.currentUser().getUser()?.getBasket().delegateReloadData = nil

        let count = Singleton.currentUser().getUser()?.getBasket().getTotalCount()
        label.isHidden = count! > 0 ? false : true
        label.text = "\(count!)"
        Singleton.currentUser().getUser()?.getBasket().initBasketFormServerForRegisterUser()
    }
    
    func showaAlert(product: Product, slug: String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restaurant.name
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
        
        
        UITabBar.appearance().tintColor = .white
        self.tabBar.barTintColor = UIColor(netHex: 0xBE232D)
        self.tabBar.unselectedItemTintColor = UIColor(netHex: 0x691319)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateBasket(count: Int) {
        let count = Singleton.currentUser().getUser()?.getBasket().getTotalCount()
        label.isHidden = count! > 0 ? false : true
        label.text = "\(count!)"
    }
    
    func basketOpen(){
        if (Singleton.currentUser().getUser()?.getBasket().productItems.count)! > 0{
            let basketViewController = self.storyboard?.instantiateViewController(withIdentifier: "BasketViewCntroller")
            self.navigationController?.pushViewController(basketViewController!, animated: true)
        }
    }

}
