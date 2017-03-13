//
//  UserInterface.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 07/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

protocol UserInterface {
    func getStatus()->STATUS
    func getProfile()->Dictionary<String,Any>?
    func getBasket()->Basket
}
