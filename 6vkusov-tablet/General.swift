//
//  General.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 03/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class General: UserInterface {
    
    private var basket:Basket
    
    init() {
        self.basket = Basket()
    }
    
    func getBasket() -> Basket {
        return self.basket
    }
    
    func getStatus() -> STATUS {
        return STATUS.GENERAL
    }
    
    func getProfile() -> Dictionary<String, Any>?{
        return nil
    }
    
    func getPoints() ->Int {return 0}
    
    func setPoints(points:Int){}
}
