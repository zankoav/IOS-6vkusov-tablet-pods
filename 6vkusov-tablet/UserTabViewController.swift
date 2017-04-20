//
//  UserTabViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/14/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class UserTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .white
        self.tabBar.barTintColor = UIColor(netHex: 0xBE232D)
        self.tabBar.unselectedItemTintColor = UIColor(netHex: 0x691319)
    }
}
