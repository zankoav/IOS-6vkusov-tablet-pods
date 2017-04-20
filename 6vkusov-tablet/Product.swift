//
//  Product.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 20/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Product {
    
    private var _id: Int
    private var _name: String
    private var _icon:String
    private var _description: String
    private var _points: Int?
    private var _category: Dictionary<String,String>
    private var _variants:[Variant]
    
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
    
    var variants: [Variant]{
        return _variants
    }
    
    var icon: String {
        return _icon
    }
    
    var description: String?{
        return _description
    }

    
    init(id :Int, name: String, icon: String, description: String, category: Dictionary<String,String>,  variants:[Variant], points: Int?){
        _id = id
        _name = name
        _points = points
        _icon = icon
        _description = description
        _category = category
        _variants = variants
    }
    
}
