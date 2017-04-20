//
//  Comment.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 20/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Comment {
    
    private var _created: String
    private var _userName: String
    private var _userIconUrl: String?
    private var _userLike: Int
    private var _text: String
    
    var created:String{
        return self._created
    }
    
    var uerName: String{
        return _userName
    }
    
    var userIconUrl:String? {
        return _userIconUrl
    }
    
    var userLike: Int {
        return _userLike
    }
    
    var text: String{
        return _text
    }
    
    init(url:String, created: String,name:String, like:Int, text: String){
        self._text = text
        self._userLike = like
        self._userName = name
        self._created = created
        self._userIconUrl = url
    }
}
