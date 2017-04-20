//
//  Promo.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation


class Promo {
    
    private var _name:String
    private var _bonus:String
    private var _iconURL: String
    private var _slug: String
    
    var name:String{
        return _name
    }
    
    var slug:String{
        return _slug
    }
    
    var iconURL:String{
        return _iconURL
    }
    
    var bonus:String{
        return _bonus
    }
    
    init(bonus: String,name: String, url: String, slug :String){
        
        self._name = name
        self._bonus = bonus
        self._slug = slug
        self._iconURL = REST_URL.SF_DOMAIN.rawValue + url
        
    }

}
