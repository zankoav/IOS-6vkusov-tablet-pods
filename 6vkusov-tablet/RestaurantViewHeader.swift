//
//  RestaurantViewHeader.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/20/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

@IBDesignable class RestaurantViewHeader: UIView, LoadJson{

    var view: UIView!
    
    @IBOutlet weak var timeWork: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var dislikeCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var kitchens: UILabel!
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    
    @IBOutlet weak var favorite: CheckBox!
    
    
    var restaurantSlug:String!
    

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        print(obj)
    }
    
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RestaurantViewHeader", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        favorite.addTarget(self, action: #selector(clickFavorite), for: UIControlEvents.touchUpInside)
        self.icon.layer.masksToBounds = true
        self.icon.layer.cornerRadius = 5
        self.addSubview(self.view)
    }
    
    func clickFavorite(){
        if Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED {
            var dict = Dictionary<String, AnyObject>()
            dict["key"] = REST_URL.KEY.rawValue as AnyObject
            dict["session"] = Singleton.currentUser().getUser()?.getProfile()?["session"] as AnyObject
            dict["slug"] = restaurantSlug as AnyObject
            print(dict)
            JsonHelperLoad.init(url: REST_URL.SF_FAVOURITE.rawValue, params: dict, act: self, sessionName: nil).startSession()
        }else{
            if favorite.isChecked {
                Singleton.currentUser().getStore()?.addFavoriteSlug(slug: restaurantSlug)
            }else{
                Singleton.currentUser().getStore()?.removeFavoriteSlug(slug: restaurantSlug)
            }
        }
    }


}
