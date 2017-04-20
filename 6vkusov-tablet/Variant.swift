//
//  Variant.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation


class Variant {
    
    private var _id: Int
    private var _price: Float
    private var _size: String?
    private var _weigth: String?
    private var _count = 1
    
    var id : Int {
        return _id
    }
    
    var count :Int {
        return _count
    }
    
    var price:Float {
        return _price
    }
    
    var size: String? {
        return _size
    }
    var  weigth : String?{
        return _weigth
    }
    
    func addCount(){
        _count += 1
    }
    
    func minusCount(){
        _count -= 1
    }
    
    init(id: Int, price: Float, size: String?, weigth :String?){
        _id =  id
        _price = price
        _size = size
        _weigth = weigth
    }
}
