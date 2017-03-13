//
//  LocalStorageZ.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 13/12/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class LocalStorage: LoadJson{
    
    public let APP_CATEGORIES = "categories"
    public let APP_RESTAURANTS = "restaurants"
    public let APP_PROFILE = "profile"
    private let vc:MainViewController
    
    init(vc: MainViewController) {
        self.vc = vc
        
        clearDataStorage(key: APP_CATEGORIES)
        clearDataStorage(key: APP_RESTAURANTS)
        
        JsonHelperLoad(url: "https://6vkusov.by/api/categories", params: nil, act: self, sessionName: APP_CATEGORIES).startSession()
        
        JsonHelperLoad(url: "https://6vkusov.by/api/restaurants", params: ["slug":"all"], act: self, sessionName: APP_RESTAURANTS).startSession()
        
        if let userProfile = getDataStorage(key: APP_PROFILE){
            print(userProfile)
            let data = userProfile.data(using: .utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject>
                if let session = json?["session"] {
                    JsonHelperLoad(url: "https://6vkusov.by/api/user", params: ["session":session as! String], act: self, sessionName: APP_PROFILE).startSession()
                }else{
                    Singleton.currentUser().setUser(user: General())
                    print("General user load")
                }
            }catch let error as NSError {
                Singleton.currentUser().setUser(user: General())
                print(error)
            }
        }else{
            Singleton.currentUser().setUser(user: General())
            print("General user load")
        }
        
    }
    
    
    
    func clearDataStorage(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func setStringValueStorage(key: String, value: String) {
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    func getDataStorage(key: String) -> String? {        
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let object = obj {
            do {
                let data = try JSONSerialization.data(withJSONObject: object, options: [])
                let json = String(data: data, encoding: .utf8)
                switch (sessionName!){
                case APP_CATEGORIES:
                    setStringValueStorage(key: APP_CATEGORIES, value: json!)
                    break
                case APP_RESTAURANTS:
                    setStringValueStorage(key:APP_RESTAURANTS, value: json!)
                    break
                case APP_PROFILE:
                    setStringValueStorage(key: APP_PROFILE, value: json!)
                    Singleton.currentUser().setUser(user: Registred())
                    break
                default:break
                }
            } catch let error as NSError {
                print("Error Server \(error)")
            }
            
            if( Singleton.currentUser().getUser() != nil &&
                getDataStorage(key: APP_CATEGORIES) != nil &&
                getDataStorage(key: APP_RESTAURANTS) != nil)
            {
                
                vc.loadComplete()
            }
        }
    }

}
