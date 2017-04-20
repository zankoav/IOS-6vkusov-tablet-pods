//
//  InfoRestaurant.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/5/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation


class InfoRestaurant{
    
    private var _descriptionInfo:String
    private var _addressInfo:String
    private var _nameInfo:String
    private var _unpInfo:String
    private var _deliveryDescriptionInfo: String
    private var _commercialRegisterInfo: String
    
    var descriptionInfo: String {return _descriptionInfo}
    
    var addressInfo: String {return _addressInfo}
    
    var nameInfo: String {return _nameInfo}
    
    var unpInfo: String {return _unpInfo}
    
    var deliveryDescriptionInfo: String {return _deliveryDescriptionInfo}
    
    var commercialRegisterInfo:String {return _commercialRegisterInfo}
    
    init(descriptionInfo: String, addressInfo: String, nameInfo: String, unpInfo: String, deliveryDescriptionInfo: String, commercialRegisterInfo: String) {
        
        _descriptionInfo = descriptionInfo
        _addressInfo = addressInfo
        _nameInfo = nameInfo
        _unpInfo = unpInfo
        _deliveryDescriptionInfo = deliveryDescriptionInfo
        _commercialRegisterInfo = commercialRegisterInfo
    }
}
