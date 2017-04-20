//
//  ProductPromo.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation


class ProductPromo : Promo{
    
    private var _restName:String
    private var _preoductDesc:String
    
    var restName:String{
        return _restName
    }
    
    var preoductDesc:String{
        return _preoductDesc
    }
    
    init(restName:String, preoductDesc: String, bonus: String,name: String, url: String, slug :String){
        
        _restName = restName
        _preoductDesc = preoductDesc
        
        super.init(bonus: bonus,name: name, url: url, slug: slug)
    }
}
