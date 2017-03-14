//
//  LocalStorageZ.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 13/12/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

public enum REST_URL: String {
    case SF_CATEGORIES = "https://6vkusov.by/api/categories"
    case SF_RESTAURANTS = "https://6vkusov.by/api/restaurants"
    case SF_USER = "https://6vkusov.by/api/user"
    case SF_DOMAIN = "https://6vkusov.by"
    case SF_LOGIN = "https://6vkusov.by/api/login"
    case SF_REGISTRATION = "https://6vkusov.by/api/register"
    
    //    case SF_RESTAURANT_MENU = "http://6vkusov:f91DCoC@6vkusov.by/api/restaurant_categories"
    //    case SF_RESTAURANT_COMMENTS = "http://6vkusov:f91DCoC@6vkusov.by/api/restaurant_comments"
    //    case SF_RESTAURANT_FOOD = "http://6vkusov:f91DCoC@6vkusov.by/api/food"
    //    case PROMOS = "http://zan.6vkusov.by/main/getPromos"
    //    case ORDER = "http://zan.6vkusov.by/main/setOrder"
    
}

class LocalStorage: LoadJson{
    
    public let APP_CATEGORIES = "categories"
    public let APP_RESTAURANTS = "restaurants"
    public let APP_PROFILE = "profile"
    private let vc:MainViewController
    
    init(vc: MainViewController) {
        self.vc = vc
        
        clearDataStorage(key: APP_CATEGORIES)
        clearDataStorage(key: APP_RESTAURANTS)
        
        JsonHelperLoad(url: REST_URL.SF_CATEGORIES.rawValue, params: nil, act: self, sessionName: APP_CATEGORIES).startSession()
        
        JsonHelperLoad(url: REST_URL.SF_RESTAURANTS.rawValue, params: ["slug":"all"], act: self, sessionName: APP_RESTAURANTS).startSession()
        
        if let userProfile = getDataStorage(key: APP_PROFILE){
            let data = userProfile.data(using: .utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject>
                if let session = json?["session"] {
                    JsonHelperLoad(url: REST_URL.SF_USER.rawValue, params: ["session":session as! String], act: self, sessionName: APP_PROFILE).startSession()
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
    
    func getMainCategories()->[Category]{
        var categories = [Category]()
        let str = getDataStorage(key: APP_CATEGORIES)
        if let data = str?.data(using: .utf8) {
            do {
                let allCategories = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                let imgPath = (allCategories["img_path"] as! String)
                let array = allCategories["categories"] as! [Dictionary<String, AnyObject>]
                for cat in array {
                    let type = cat["type"] as! Int
                    let name = cat["name"] as! String
                    let slug = cat["slug"] as! String
                    if (type == 1) {
                        let url = (imgPath + "/" + (cat["image"] as! String))
                        categories.append(Category(name: name, url: url, type: type, slug: slug))
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return categories
    }
    
    func getSecoundaryCategories()->[Category]{
        var categories = [Category]()
        let str = getDataStorage(key: APP_CATEGORIES)
        if let data = str?.data(using: .utf8) {
            do {
                let allCategories = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                let array = allCategories["categories"] as! [Dictionary<String, AnyObject>]
                for cat in array {
                    let type = cat["type"] as! Int
                    let name = cat["name"] as! String
                    let slug = cat["slug"] as! String
                    if (type == 2) {
                        categories.append(Category(name: name, url: nil, type: type, slug: slug))
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return categories
    }
    
    func getAllRestaurants()->[Restaurant]{
        var restaurants = [Restaurant]()
        let str = getDataStorage(key: APP_RESTAURANTS)
        if let data = str?.data(using: .utf8) {
            do {
                let allRestaurants = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                let img_path = allRestaurants["img_path"] as! String
                let array = allRestaurants["restaurants"] as! [Dictionary<String,AnyObject>]
                for rest in array {
                    let slug = rest["slug"] as! String
                    let name = rest["name"] as! String
                    let working_time = rest["working_time"] as! String
                    let minimal_price = rest["minimal_price"] as! Float
                    var delivery_time = rest["delivery_time"] as? String
                    if delivery_time == nil{
                        delivery_time = ""
                    }
                    let kitchens = rest["kitchens"] as! [String]
                    var description = rest["description"] as? String
                    if description == nil{
                        description = ""
                    }
                    let logoImg = rest["logo"] as? String
                    var iconURL = ""
                    if let logo = logoImg{
                        iconURL = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + logo
                    }
                    
                    let comments = rest["comments"] as! Dictionary<String,Int>
                    let restaurant = Restaurant(slug: slug, name: name, working_time: working_time, minimal_price: minimal_price, delivery_time: delivery_time!, kitchens: kitchens, description: description!, iconURL: iconURL, comments: comments)
                    restaurants.append(restaurant)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return restaurants
    }
    
    
}
