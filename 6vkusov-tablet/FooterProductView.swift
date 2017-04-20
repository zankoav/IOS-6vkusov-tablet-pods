//
//  FooterProductView.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/23/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

@IBDesignable class FooterProductView: UIView {

    var view: UIView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var points: UILabel!
    
    var isFreeFood:Bool!

    var product :Product!
    var slug :String!
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction func productAdd(_ sender: Any) {
        if isFreeFood {
            if Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED {
                if !(Singleton.currentUser().getUser()?.getBasket().isFreeFoodExist)! && (Singleton.currentUser().getUser()?.getPoints())! >= product.points! {
                    Singleton.currentUser().getUser()?.getBasket().addProductFromRestaurantOrder(product: product, slug: slug)
                }
            }
        }else{
            Singleton.currentUser().getUser()?.getBasket().addProductFromRestaurantOrder(product: product, slug: slug)
        }
    }
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FooterProductView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.layer.cornerRadius = 5
        self.addSubview(self.view)
    }
    


}
