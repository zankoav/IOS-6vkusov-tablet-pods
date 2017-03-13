//
//  Singleton.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 03/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Singleton {
    
    private var user: UserInterface?
    private var store: LocalStorage?
    private static let singleton: Singleton = Singleton()
    
    static func currentUser() -> Singleton {
        return singleton
    }
    
    func initStore(vc: MainViewController) {
        self.store = LocalStorage(vc: vc)
    }
    
    func getUser()-> UserInterface? {
        return user
    }
    
    func setUser(user: UserInterface) {
        self.user = user
    }
    
    func  getStore()->LocalStorage? {
        return store
    }
    
}
