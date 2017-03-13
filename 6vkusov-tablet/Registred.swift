//
//  Registred.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 03/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Registred: UserInterface {
    
    private var basket:Basket
    
    init() {
        self.basket = Basket()
    }
    
    func getBasket() -> Basket {
        return self.basket
    }
    
    func getStatus() -> STATUS {
        return STATUS.REGISTRED
    }
    
    func getProfile() -> Dictionary<String, Any>?{
        let store = Singleton.currentUser().getStore()
        let json = store?.getDataStorage(key: (store?.APP_PROFILE)!)
        let data = json?.data(using: .utf8)
        do {
            return try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,Any>
        }catch let error as NSError {
            Singleton.currentUser().setUser(user: General())
            print(error)
        }
        return nil
    }
    
}
