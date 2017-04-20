//
//  TitleHeader.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 05/09/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import UIKit
import SCLAlertView


@IBDesignable class TitleHeader: UIView, LoadJson{

    var view: UIView!
    var order:Order!
    var index:Bool = true {
        didSet{
            viewMain.backgroundColor = index ? UIColor(netHex: 0xFFF8EE) : UIColor(netHex: 0xF5FBFF)
        }
    }
    
    var comment = [String:AnyObject]()
    
    var textfield:UITextView!
    var like,dislike :SSRadioButton!
    var sendButton: UIButton!
    var alert: SCLAlertView!
    var radioButtonController: SSRadioButtonsController?
    

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameRest: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var buttonComments: UIButton!
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction func comment(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            hideWhenBackgroundViewIsTapped:true
        )
        
        // Initialize SCLAlertView using custom Appearance
        alert = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: 220))
        let x = (subview.frame.width - 180) / 2
        

        textfield = UITextView(frame: CGRect(x: x, y: 10, width: 180, height: 80))
        textfield.layer.borderColor = UIColor(netHex: 0x8FB327).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        textfield.layer.cornerRadius = 5
        subview.addSubview(textfield)
        
        like = SSRadioButton(frame: CGRect(x: x, y: textfield.frame.maxY + 5, width: 180, height: 25))
        like.setTitle("Нравиться", for: .normal)
        like.setTitleColor(UIColor.black, for: .normal)
        like.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        like.isSelected = true
        subview.addSubview(like)
        
        dislike = SSRadioButton(frame: CGRect(x: x, y: like.frame.maxY + 5, width: 180, height: 25))
        dislike.setTitle("Не нравиться", for: .normal)
        dislike.setTitleColor(UIColor.black, for: .normal)
        dislike.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        subview.addSubview(dislike)
        
        sendButton = UIButton(frame: CGRect(x: x, y: dislike.frame.maxY + 10, width: 180, height: 25))
        sendButton.addTarget(self, action: #selector(sendComment), for:UIControlEvents.touchUpInside)
        sendButton.backgroundColor = UIColor(netHex: 0x8FB327)
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = sendButton.bounds.height/2
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        subview.addSubview(sendButton)
        
        let canselButton = UIButton(frame: CGRect(x: x, y: sendButton.frame.maxY + 10, width: 180, height: 25))
        canselButton.addTarget(self, action: #selector(consel), for:UIControlEvents.touchUpInside)
        canselButton.backgroundColor = UIColor(netHex: 0x8FB327)
        canselButton.layer.masksToBounds = true
        canselButton.layer.cornerRadius = sendButton.bounds.height/2
        canselButton.setTitle("Отмена", for: .normal)
        canselButton.setTitleColor(UIColor.white, for: .normal)
        canselButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        subview.addSubview(canselButton)


        radioButtonController = SSRadioButtonsController(buttons: like, dislike)
        
        alert.customSubview = subview
        
        alert.showEdit(
            "Напишите отзыв",
            subTitle: "Написав отзыв вы получаите +200 баллов",
            colorStyle: 0x8FB327,
            colorTextButton: 0xFFFFFF
        )
    }
    
    func consel(){
        alert.hideView()
    }
    
    func sendComment(){
        
        if textfield.text == "" {
            textfield.layer.borderColor = UIColor(netHex: 0xBE232D).cgColor
            return
        }
        
        comment["type"] = (like.isSelected ? 1 : 2) as AnyObject
        comment["session"] = Singleton.currentUser().getUser()!.getProfile()!["session"] as! String as AnyObject
        comment["text"] = textfield.text as AnyObject
        comment["id"] = order.id as AnyObject
        comment["key"] = REST_URL.KEY.rawValue as AnyObject
        
        JsonHelperLoad.init(url: REST_URL.SF_SEND_COMMENT.rawValue, params: comment, act: self, sessionName: nil).startSession()
        alert.hideView()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let request = obj{
            if let successful = request["status"] as? String{
                if successful == "successful"{
                    buttonComments.isHidden = true
                }
            }
        }
    }
    
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TitleHeader", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //here you can add things to your view....
        self.addSubview(self.view)
    }

}
