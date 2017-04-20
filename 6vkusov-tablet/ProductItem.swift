//
//  ProductItem.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/6/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation

class ProductItem {
    
    private var _id: Int
    private var _name: String
    private var _icon:String
    private var _description: String?
    private var _points: Int?
    private var _category: Dictionary<String,String>
    private var _variant:Variant
    private var _count: Int
    
    
    var count:Int{
        return _count
    }
    
    func addCount(){
        _count += 1
    }
    
    func addCountTo(count:Int){
        _count += count
    }
    
    func setCount(count:Int){
        _count = count
    }
    
    
    func minusCount(){
        _count -= 1
    }
    
    var id: Int{
        return _id
    }
    
    var name: String{
        return _name
    }
    
    var points: Int?{
        return _points
    }
    
    var category: Dictionary<String,String>{
        return _category
    }
    
    var variant: Variant{
        return _variant
    }
    
    var icon: String {
        return _icon
    }
    
    var description: String?{
        return _description
    }
    
    
    init(id :Int, name: String, icon: String, description: String?, category: Dictionary<String,String>,  variant:Variant, points: Int?){
        _id = id
        _name = name
        _points = points
        _icon = icon
        _description = description
        _category = category
        _variant = variant
        _count = variant.count
    }

    
}
