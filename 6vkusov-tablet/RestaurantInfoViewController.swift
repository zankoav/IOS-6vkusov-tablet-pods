//
//  RestaurantInfoViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantInfoViewController: BaseViewController {

    @IBOutlet weak var restaurentInfo: UITextView!

    override func viewDidAppear(_ animated: Bool) {
        restaurentInfo.isScrollEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabController = self.tabBarController as! RestaurantTabController
        restaurentInfo.isScrollEnabled = false
        restaurentInfo.text = tabController.restaurant.info.descriptionInfo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
