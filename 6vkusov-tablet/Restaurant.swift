//
//  Restaurant.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 13/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Restaurant {
    
    
    private var _slug:String
    private var _name:String
    private var _working_time:String
    private var _minimal_price:Float
    private var _delivery_time: String
    private var _kitchens: [String]
    private var _description: String
    private var _iconURL: String
    private var _comments: Dictionary<String,Int>

    
    var slug:String{return _slug}
    
    var name:String{return _name}
    
    var working_time:String{return _working_time}
    
    var minimal_price:Float{return _minimal_price}
    
    var delivery_time:String{return _delivery_time}
    
    var kitchens:[String]{return _kitchens}
    
    var description:String{return _description}

    var iconURL:String{return _iconURL}

    var comments: Dictionary<String,Int>{return _comments}
    
    var isNew :Bool {return true}
    
    var isFreeFood :Bool {return false}
    
    var isPromo :Bool {return true}
    
    var isSale :Bool {return false}

    
    init(slug: String, name: String, working_time: String, minimal_price: Float, delivery_time: String, kitchens: [String], description: String, iconURL: String, comments: Dictionary<String,Int>){
        
        self._slug = slug
        self._name = name
        self._working_time = working_time
        self._minimal_price = minimal_price
        self._delivery_time = delivery_time
        self._kitchens = kitchens
        self._description = description
        self._iconURL = iconURL
        self._comments = comments

    }
    
    func getKitchens() ->String{
        return kitchens.joined(separator: ", ")
    }
}
