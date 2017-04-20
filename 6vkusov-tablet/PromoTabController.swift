//
//  PromoTabController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class PromoTabController: UITabBarController, BasketViewDelegate {
    
    private var button:UIBarButtonItem?
    private var label:UILabel!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.currentUser().getUser()?.getBasket().delegate = self
        label.text = "1"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func updateBasket(count: Int) {
        label.text = "\(count)"
    }
    
    func basketOpen(){
        if (Singleton.currentUser().getUser()?.getBasket().productItems.count)! > 0{
            let basketViewController = self.storyboard?.instantiateViewController(withIdentifier: "BasketViewCntroller")
            self.navigationController?.pushViewController(basketViewController!, animated: true)
        }
    }

    func showaAlert(product: Product, slug: String) {
        
    }

}
