//
//  Validator.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/24/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation

class Validator {
    
    class func email(email:String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    class func minLength(password:String, length: Int)->Bool{
        return password.length >= length ? true : false;
    }
    
    class func maxLength(password:String, length: Int)->Bool{
        return password.length <= length ? true : false;
    }
    
    class func nameLiterals(name:String)->Bool{
        let nameRegEx = "^[a-zA-ZА-Яа-я]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
    class func nameLiteralsAndNumbers(name:String)->Bool{
        let nameRegEx = "^[a-zA-ZА-Яа-я0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }
    
    class func onlyNumbers(name:String)->Bool{
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name)
    }

}
