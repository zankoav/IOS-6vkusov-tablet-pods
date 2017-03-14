//
//  RestaurantTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/13/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var kichenType: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var dislikesCounts: UILabel!
    
    @IBOutlet weak var deliveryPriceTitle: UILabel!
    @IBOutlet weak var deliveryTimeTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 5.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        rotated()
    }
    
    func rotated() {
        let width = UIScreen.main.bounds.width
        let sizeTitle = UIDeviceOrientationIsLandscape(UIDevice.current.orientation) ? width/40 : width/30
        let sizeText = UIDeviceOrientationIsLandscape(UIDevice.current.orientation) ? width/60 : width/45
        kichenType.font = kichenType.font.withSize(sizeText)
        deliveryPrice.font = deliveryPrice.font.withSize(sizeText)
        deliveryTime.font = deliveryTime.font.withSize(sizeText)
        likeCounts.font = likeCounts.font.withSize(sizeText)
        dislikesCounts.font = dislikesCounts.font.withSize(sizeText)
        deliveryPriceTitle.font = deliveryPriceTitle.font.withSize(sizeText)
        deliveryTimeTitle.font = deliveryTimeTitle.font.withSize(sizeText)
        name.font = name.font.withSize(sizeTitle)
    }

}
