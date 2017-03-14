//
//  Category.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 10/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Category {

    private var _name:String
    private var _iconURL: String?
    private var _slug: String
    private var _type: Int
    
    var name:String{
        return _name
    }
    
    var slug:String{
        return _slug
    }
    
    var type: Int{
        return _type
    }
    
    var iconURL:String?{
        return _iconURL
    }
    
    init(name: String, url: String?, type: Int, slug :String){
        
        self._name = name
        self._slug = slug
        self._type = type
        
        if let uri = url{
            self._iconURL = REST_URL.SF_DOMAIN.rawValue + uri
        }
    }
}
