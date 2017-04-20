//
//  LocalStorageZ.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 13/12/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

public enum REST_URL: String {
    case SF_DOMAIN = "https://6vkusov.by"
    case KEY = "252cbf79f74f36e0df806817847a0e1b"
    
    case SF_LOGIN = "https://6vkusov.by/api/login"
    case SF_REGISTRATION = "https://6vkusov.by/api/register"
    case SF_RESET_PASSWORD = "https://6vkusov.by/api/reset_password"
    case SF_CATEGORIES = "https://6vkusov.by/api/categories"
    case SF_RESTAURANTS = "https://6vkusov.by/api/restaurants"
    case SF_RESTAURANT_FOOD = "https://6vkusov.by/api/food"
    case SF_SEND_ORDER = "https://6vkusov.by/api/send_order"
    case SF_ORDERS = "https://6vkusov.by/api/orders"
    case SF_USER = "https://6vkusov.by/api/user"
    case SF_COMMENTS = "https://6vkusov.by/api/restaurant_comments"
    case SF_SEND_COMMENT = "https://6vkusov.by/api/send_comment"
    case SF_ADD_VARIANTS = "https://6vkusov.by/api/add_variants"
    case SF_REMOVE_VARIANT = "https://6vkusov.by/api/remove_variant"
    case SF_REMOVE_ITEM = "https://6vkusov.by/api/remove_item"
    case SF_CHECKOUT_CART = "https://6vkusov.by/api/checkout_cart"
    case SF_BASKET_ITEMS = "https://6vkusov.by/api/basket_items"
    case SF_FAVOURITE = "https://6vkusov.by/api/favourite"
    case SF_FAVOURITES = "https://6vkusov.by/api/favourites"
    case SF_INVIREMENT = "https://6vkusov.by/api/invite"
    case SF_GET_USER_POINTS = "https://6vkusov.by/api/user_points"
}

class LocalStorage: LoadJson{
    
    public let APP_CATEGORIES = "categories"
    public let APP_RESTAURANTS = "restaurants"
    public let APP_PROFILE = "profile"
    public let APP_SLUGS = "slugs"
    
    public let BOUNUS_BY_BYN = 5
    
    private let vc:MainViewController
    
    init(vc: MainViewController) {
        self.vc = vc
        
        clearDataStorage(key: APP_CATEGORIES)
        clearDataStorage(key: APP_RESTAURANTS)
        
        JsonHelperLoad(url: REST_URL.SF_CATEGORIES.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject], act: self, sessionName: APP_CATEGORIES).startSession()
        
        JsonHelperLoad(url: REST_URL.SF_RESTAURANTS.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject], act: self, sessionName: APP_RESTAURANTS).startSession()
        
        if let userProfile = getDataStorage(key: APP_PROFILE){
            let data = userProfile.data(using: .utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject>
                if let session = json?["session"] {
                    JsonHelperLoad(url: REST_URL.SF_USER.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject, "session":session as AnyObject], act: self, sessionName: APP_PROFILE).startSession()
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
                    let objectUser = object["user"] as! Dictionary<String, AnyObject>
                    let dataUser = try JSONSerialization.data(withJSONObject: objectUser, options: [])
                    let jsonUser = String(data: dataUser, encoding: .utf8)
                    setStringValueStorage(key: APP_PROFILE, value: jsonUser!)
                    Singleton.currentUser().setUser(user: Registred(points:objectUser["points"] as! Int))
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
                let message = (allCategories["message"] as! Dictionary<String, AnyObject>)
                let imgPath = (message["img_path"] as! String)
                let array = message["categories"] as! [Dictionary<String, AnyObject>]
                for cat in array {
                    let name = cat["name"] as! String
                    let slug = cat["slug"] as! String
                    let type = cat["type"] as! Int
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
                let message = (allCategories["message"] as! Dictionary<String, AnyObject>)
                let array = message["categories"] as! [Dictionary<String, AnyObject>]
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
    
    
    func getRestaurants(slug:String)->[Restaurant]{
        var restaurants = [Restaurant]()
        let str = getDataStorage(key: APP_RESTAURANTS)
        if let data = str?.data(using: .utf8) {
            do {
                let allRestaurants = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                let img_path = allRestaurants["img_path"] as! String
                let array = allRestaurants["restaurants"] as! [Dictionary<String,AnyObject>]
                for rest in array {
                    
                    let name = rest["name"] as! String
                    let slug = rest["slug"] as! String
                    let logoImg = rest["logo"] as? String
                    var iconURL = ""
                    
                    if let logo = logoImg{
                        iconURL = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + logo
                    }
                    
                    let working_time = rest["working_time"] as! String
                    let minimal_price = rest["minimal_price"] as! Float
                    var delivery_time = rest["delivery_time"] as? String
                    
                    if delivery_time == nil{
                        delivery_time = ""
                    }
                    
                    let comments = rest["comments"] as! Dictionary<String,Int>
                    
                    let about = rest["about"] as? Dictionary<String,AnyObject>
                    let kitchens = about?["kitchens"] as? String
                    let info = about?["info"] as? Dictionary<String,String>
                    
                    var descriptionInfo = ""
                    if let desc = info?["description"] {
                        descriptionInfo = desc
                    }
                    
                    var addressInfo  = ""
                    if let ad = info?["address"] {
                        addressInfo = ad
                    }
                    
                    var nameInfo = ""
                    if let ad = info?["unp"] {
                        nameInfo = ad
                    }
                    
                    var unpInfo = ""
                    if let ad = info?["unp"] {
                        unpInfo = ad
                    }
                    
                    var deliveryDescriptionInfo = ""
                    if let ad = info?["delivery_description"] {
                        deliveryDescriptionInfo = ad
                    }
                    
                    var commercialRegisterInfo = ""
                    if let ad = info?["commercial_register"] {
                        commercialRegisterInfo = ad
                    }
                    
                    let infoRest = InfoRestaurant(descriptionInfo: descriptionInfo, addressInfo: addressInfo,nameInfo: nameInfo, unpInfo: unpInfo, deliveryDescriptionInfo: deliveryDescriptionInfo, commercialRegisterInfo: commercialRegisterInfo)
                    
                    let categoriesSlugs = rest["categories_slugs"] as! [String]
                    
                    let restaurant = Restaurant(slug: slug, name: name, working_time: working_time, minimal_price: minimal_price, delivery_time: delivery_time!, kitchens: kitchens ?? "", info: infoRest, iconURL: iconURL, comments: comments, categoriesSlugs:categoriesSlugs)
                    restaurants.append(restaurant)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        if slug == "all"{
            return restaurants
        }else{
            return getRestaurantsBySlug(restaurants: restaurants,slug: slug)
        }
    }
    
    func getFavoriteRestaurants(slugs: [String])->[Restaurant]{
        var rests = [Restaurant]()
        let restaurants = getRestaurants(slug: "all")
        for r in restaurants {
            if(slugs.contains(r.slug)){
                rests.append(r)
            }
        }
        return rests
    }
    
    private func getRestaurantsBySlug(restaurants: [Restaurant], slug: String)->[Restaurant]{
        var rests = [Restaurant]()
        for r in restaurants {
            if(r.categoriesSlugs.contains(slug)){
                rests.append(r)
            }
        }
        return rests
    }
    
    func getRestaurantBySlugName(slug:String) -> Restaurant?{
        let str = getDataStorage(key: APP_RESTAURANTS)
        if let data = str?.data(using: .utf8) {
            do {
                let allRestaurants = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                let img_path = allRestaurants["img_path"] as! String
                let array = allRestaurants["restaurants"] as! [Dictionary<String,AnyObject>]
                for rest in array {
                    let slugRest = rest["slug"] as! String
                    if slugRest != slug {
                        continue
                    }
                    let name = rest["name"] as! String
                    let slug = rest["slug"] as! String
                    let logoImg = rest["logo"] as? String
                    var iconURL = ""
                    
                    if let logo = logoImg{
                        iconURL = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + logo
                    }
                    
                    let working_time = rest["working_time"] as! String
                    let minimal_price = rest["minimal_price"] as! Float
                    var delivery_time = rest["delivery_time"] as? String
                    
                    if delivery_time == nil{
                        delivery_time = ""
                    }
                    
                    let comments = rest["comments"] as! Dictionary<String,Int>
                    
                    let about = rest["about"] as? Dictionary<String,AnyObject>
                    let kitchens = about?["kitchens"] as? String
                    let info = about?["info"] as? Dictionary<String,String>
                    
                    var descriptionInfo = ""
                    if let desc = info?["description"] {
                        descriptionInfo = desc
                    }
                    
                    var addressInfo  = ""
                    if let ad = info?["address"] {
                        addressInfo = ad
                    }
                    
                    var nameInfo = ""
                    if let ad = info?["unp"] {
                        nameInfo = ad
                    }
                    
                    var unpInfo = ""
                    if let ad = info?["unp"] {
                        unpInfo = ad
                    }
                    
                    var deliveryDescriptionInfo = ""
                    if let ad = info?["delivery_description"] {
                        deliveryDescriptionInfo = ad
                    }
                    
                    var commercialRegisterInfo = ""
                    if let ad = info?["commercial_register"] {
                        commercialRegisterInfo = ad
                    }
                    
                    let infoRest = InfoRestaurant(descriptionInfo: descriptionInfo, addressInfo: addressInfo,nameInfo: nameInfo, unpInfo: unpInfo, deliveryDescriptionInfo: deliveryDescriptionInfo, commercialRegisterInfo: commercialRegisterInfo)
                    
                    let categoriesSlugs = rest["categories_slugs"] as! [String]
                    
                    let restaurant = Restaurant(slug: slug, name: name, working_time: working_time, minimal_price: minimal_price, delivery_time: delivery_time!, kitchens: kitchens ?? "", info: infoRest, iconURL: iconURL, comments: comments, categoriesSlugs:categoriesSlugs)
                    return restaurant
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func getAllSlugs()->[String]? {
        if let slugsStr = getDataStorage(key: APP_SLUGS) {
            if let data = slugsStr.data(using: .utf8) {
                do {
                    let slugs = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                    return slugs
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return nil
    }
    
    func addFavoriteSlug(slug:String){
        var slugs = getAllSlugs()
        if  slugs != nil {
            if !slugs!.contains(slug) {
                slugs!.append(slug)
            }
        }else{
            slugs = [slug]
        }
        do {
            let dataSlugs = try JSONSerialization.data(withJSONObject: slugs!, options: [])
            let jsonSlugs = String(data: dataSlugs, encoding: .utf8)
            setStringValueStorage(key: APP_SLUGS, value: jsonSlugs!)
        }catch let error as NSError {
            print(error)
        }
    }
    
    func removeFavoriteSlug(slug:String){
        var slugs = getAllSlugs()
        if  slugs != nil {
            if  let index = slugs!.index(of: slug){
                slugs!.remove(at: index)
                do {
                    let dataSlugs = try JSONSerialization.data(withJSONObject: slugs!, options: [])
                    let jsonSlugs = String(data: dataSlugs, encoding: .utf8)
                    setStringValueStorage(key: APP_SLUGS, value: jsonSlugs!)
                }catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    func isFavoriteSlug(slug: String)->Bool{
        if let slugs = getAllSlugs() {
            return slugs.contains(slug)
        }
        return false
    }
    
    
}
