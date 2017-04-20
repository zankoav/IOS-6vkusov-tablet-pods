//
//  BasketUser.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 25/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

protocol BasketViewDelegate {
    func updateBasket(count:Int)
    func showaAlert(product: Product, slug: String)
}

protocol ReloadFreeFoodTableView {
    func reloadTableView()
}

class Basket: LoadJson{
    
    var delegate: BasketViewDelegate?
    var productItems = [ProductItem]()
    var isFreeFoodExist = false
    var delegateReloadData: ReloadFreeFoodTableView?
    
    var slugRestaurant:String?
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        print(obj)
        if sessionName == "add" {
            if let request = obj {
                if let status = request["status"] as? String{
                    if status == "successful"{
                        self.productItems = [ProductItem]()
                        if let empty = request["empty"] as? Bool {
                            if !empty {
                                let image_path = REST_URL.SF_DOMAIN.rawValue + (request["img_path"] as! String) + "/"
                                slugRestaurant = request["slug"] as? String
                                let basket = request["basket"] as! [Dictionary<String,AnyObject>]
                                var freeFoodContains = false
                                for item in basket {
                                    let idProduct = item["id"] as! Int
                                    let nameProduct = item["name"] as! String
                                    let iconProduct = item["icon"] as! String
                                    let iconDescription = item["description"] as? String
                                    let variantData = item["variant"] as! Dictionary<String, AnyObject>
                                    let variantId = variantData["id"] as! Int
                                    let variantPrice = variantData["price"] as! Float
                                    let variantSize = variantData["size"] as? String
                                    let variantWeight = variantData["weight"] as? String
                                    let categoryData = item["category"] as! Dictionary<String, String>
                                    let variant = Variant(id: variantId, price: variantPrice, size: variantSize, weigth: variantWeight)
                                    let points = item["points"] as? Int
                                    if points != nil {
                                        freeFoodContains = true
                                    }
                                    let productItem = ProductItem(id: idProduct, name: nameProduct, icon: image_path + iconProduct, description: iconDescription, category: categoryData, variant: variant, points: points)
                                    let count = item["count"] as! Int
                                    productItem.setCount(count: count)
                                    productItems.append(productItem)
                                }
                                isFreeFoodExist = freeFoodContains
                                delegateReloadData?.reloadTableView()
                                self.delegate?.updateBasket(count: getTotalCount())
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func initBasketFormServerForRegisterUser(){
        if  Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED{
            if let session  = Singleton.currentUser().getUser()?.getProfile()?["session"] as? String {
                JsonHelperLoad.init(url: REST_URL.SF_BASKET_ITEMS.rawValue, params: ["key":(REST_URL.KEY.rawValue as AnyObject as AnyObject) as! String as AnyObject,"session":session as AnyObject], act: self, sessionName: "add").startSession()
            }
            
        }
    }
    
    private func addVariantsByRegisterUser(product: Product){
        if  Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED{
            if let points  = product.points {
                if points > 0{
                    if isFreeFoodExist {
                        return
                    }else{
                        isFreeFoodExist = true
                    }
                }
            }
            if let session  = Singleton.currentUser().getUser()?.getProfile()?["session"] as? String {
                var variants = [Dictionary<String,Int>]()
                for variant in product.variants {
                    variants.append(["id":variant.id, "count":variant.count])
                }
                var points = false
                if let isPoints = product.points{
                    points = isPoints > 0 ? true : false
                }
                let dict = ["key":REST_URL.KEY.rawValue as AnyObject,"session":session as AnyObject, "variants":variants as AnyObject, "slug":slugRestaurant as AnyObject,"points": points as AnyObject]
                JsonHelperLoad.init(url: REST_URL.SF_ADD_VARIANTS.rawValue, params: dict, act: self, sessionName: "add").startSession()
            }
            
        }
    }
    
    private func addVariantByRegisterUser(productItem:ProductItem){
        if  Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED{
            if let session  = Singleton.currentUser().getUser()?.getProfile()?["session"] as? String {
                var variants = [Dictionary<String,Int>]()
                let variant = ["id":productItem.variant.id, "count":1]
                variants.append(variant)
                let dict = ["key":REST_URL.KEY.rawValue as AnyObject,"session":session as AnyObject, "variants":variants as AnyObject, "slug":slugRestaurant as AnyObject]
                JsonHelperLoad.init(url: REST_URL.SF_ADD_VARIANTS.rawValue, params: dict, act: self, sessionName: "add").startSession()
            }
            
        }
    }
    
    private func removeItemByRegisterUser(productItem:ProductItem){
        if  Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED{
            if let session  = Singleton.currentUser().getUser()?.getProfile()?["session"] as? String {
                let dict = ["key":REST_URL.KEY.rawValue as AnyObject,"session":session as AnyObject, "variant_id":productItem.variant.id as AnyObject]
                if productItem.points != nil {
                    isFreeFoodExist = false
                }
                JsonHelperLoad.init(url: REST_URL.SF_REMOVE_ITEM.rawValue, params: dict, act: self, sessionName: "minusItem").startSession()
            }
            
        }
    }
    private func removeVariantByRegisterUser(productItem: ProductItem){
        if  Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED{
            if let session  = Singleton.currentUser().getUser()?.getProfile()?["session"] as? String {
                let dict = ["key":REST_URL.KEY.rawValue as AnyObject,"session":session as AnyObject, "variant_id":productItem.variant.id as AnyObject]
                JsonHelperLoad.init(url: REST_URL.SF_REMOVE_VARIANT.rawValue, params: dict, act: self, sessionName: "minusVariant").startSession()
            }
            
        }
    }
    
    
    /**
     * вызывается кнопкой заказать
     */
    func addProductFromRestaurantOrder(product: Product, slug: String){
        if productItems.count == 0 {
            slugRestaurant = slug
            addProductToBasket(product: product)
            addVariantsByRegisterUser(product: product)
        }else{
            if slugRestaurant != slug{
                delegate?.showaAlert(product: product, slug: slug)
            }else{
                addProductToBasket(product: product)
                addVariantsByRegisterUser(product: product)
            }
        }
    }
    
    /**
     * вызывается из алерта при согласии смены ресторана
     */
    func resetBasket(product: Product, slug: String){
        productItems = [ProductItem]()
        addProductFromRestaurantOrder(product: product, slug: slug)
        delegate?.updateBasket(count: getTotalCount())
    }
    
    
    /**
     * вызывается из корзины при добавлении варианта в корзине
     */
    func addProductItemFromBasket(productItem: ProductItem){
        if self.productItems.contains(where: { element -> Bool in
            if element.variant.id == productItem.variant.id {
                element.addCount()
                return true
            }else{
                return false
            }
        }){
            addVariantByRegisterUser(productItem:productItem)
            delegate?.updateBasket(count: getTotalCount())
        }
    }
    
    /**
     * вызывается из корзины при удалении количества вариантов
     */
    func minusProductItemFromBasket(id: Int){
        for itemProduct in productItems{
            if itemProduct.variant.id == id {
                if itemProduct.count > 1 {
                    itemProduct.minusCount()
                    removeVariantByRegisterUser(productItem:itemProduct)
                }else{
                    removeProductItem(productItem: itemProduct)
                }
            }
        }
        delegate?.updateBasket(count: getTotalCount())
    }
    
    
    /**
     * вызывается из корзины при полном удалении продукта
     */
    func removeProductItem(productItem: ProductItem){
        if let index = self.productItems.index(where: { element -> Bool in
            return productItem.id == element.id
        }){
            self.productItems.remove(at: index)
            removeItemByRegisterUser(productItem: productItem)
        }
        delegate?.updateBasket(count: getTotalCount())
    }
    
    private func addProductToBasket(product: Product){
        for variant in product.variants{
            if variant.count > 0 {
                if productItems.count > 0 {
                    if !self.productItems.contains(where: { element -> Bool in
                        if element.variant.id == variant.id {
                            element.addCountTo(count: variant.count)
                            return true
                        }else{
                            return false
                        }
                    }){
                        self.productItems.append(ProductItem(id: product.id, name: product.name, icon: product.icon, description: product.description!, category: product.category, variant: variant, points: product.points))
                    }
                }else{
                    self.productItems.append(ProductItem(id: product.id, name: product.name, icon: product.icon, description: product.description!, category: product.category, variant: variant, points: product.points))
                }
            }
        }
        delegate?.updateBasket(count: getTotalCount())
    }
    
    func getTotalCount() -> Int{
        var count = 0
        for item in productItems {
            count += item.count
        }
        return count
    }
    
    func getTotalPriceFromItems()->Float{
        var price:Float = 0.0
        for item in productItems {
            price += item.variant.price*Float(item.count)
        }
        return price
    }
    
    func getTotalPrice()->Float{
        let price = getTotalPriceFromItems()
        //  var restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!)
        let deliveryPrice:Float = 0
        return price + deliveryPrice
    }
    
    func getTotalPoints()->Int{
        var bonus = 0
        let totalPriceNumber = getTotalPrice()
        bonus = Int(roundf(totalPriceNumber > 0 ? (totalPriceNumber-0.5):totalPriceNumber))*(Singleton.currentUser().getStore()?.BOUNUS_BY_BYN)!
        return bonus
    }
    
    
    func isBasketReady()->Bool{
        if let restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!) {
            return getTotalPrice() - restaurant.minimal_price >= 0
        }else{
            return false
        }
    }
    
    func getMinimalPrice()-> Float{
        let restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!)
        return restaurant!.minimal_price
    }
    
    func getOrderFromGeneralUser() -> [Dictionary<String, Int>]{
        var variants = [Dictionary<String, Int>]()
        for item in productItems {
            let dict = ["id":item.variant.id,"count":item.count]
            variants.append(dict)
        }
        return variants
    }
}
