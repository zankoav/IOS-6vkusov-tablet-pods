//
//  UserTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var labelPlus: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var datePicer: UIDatePicker!
    
    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    @IBAction func datePicerAction(_ sender: Any) {
        
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        labelPlus.layer.masksToBounds = true
        labelPlus.layer.cornerRadius = labelPlus.bounds.height/2
        datePicer.setValuesForKeys(["textColor" : UIColor.white])
    }

}
