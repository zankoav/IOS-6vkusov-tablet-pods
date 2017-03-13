//
//  LoadJson.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/24/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation

protocol LoadJson {
    func loadComplete(obj:Dictionary<String,AnyObject>?, sessionName:String?)
}
