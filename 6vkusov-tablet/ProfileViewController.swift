//
//  ProfileViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/3/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LoadJson {
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var bonusUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var saggestsTableView: UITableView!
    
    private var seggests:[Suggest] = []
    private var heightCell:CGFloat = 0
    
    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Профиль"
        
        bonusUser.isHidden = true
        var dict = Dictionary<String,AnyObject>()
        dict["key"] = REST_URL.KEY.rawValue as AnyObject
        dict["session"] = Singleton.currentUser().getUser()?.getProfile()?["session"] as AnyObject
        JsonHelperLoad.init(url: REST_URL.SF_GET_USER_POINTS.rawValue, params: dict, act: self, sessionName: nil).startSession()
    }

    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let json = obj {
            if let points = json["points"] as? Int {
                Singleton.currentUser().getUser()?.setPoints(points: points)
                bonusUser.text = "\(points) баллов "
                bonusUser.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightCell = UIScreen.main.bounds.height/3
        
        seggests = [
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara")
        ]
        initViews()
    }

    private func initViews(){
        
        bonusUser.layer.masksToBounds = true
        bonusUser.layer.cornerRadius = 5
        
        imageUser.layer.masksToBounds = true
        imageUser.layer.cornerRadius = imageUser.bounds.width/2
        
        let firstName = userData?["firstName"] as! String
        if let lastName = userData?["lastName"] as? String {
            nameUser.text = firstName + " " + lastName
        }else{
            nameUser.text = firstName
        }
        
        let img_path = userData?["img_path"] as! String
        if let avatar = userData?["avatar"] as? String {
            let url = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + avatar
            imageUser.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"checkBoxOn"))
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seggests.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Персональные предложения"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "suggest_cell") as! SuggestTableViewCell
        cell.name.text = seggests[indexPath.row].name
        cell.icon.sd_setImage(with: URL(string: seggests[indexPath.row].iconURL), placeholderImage: UIImage(named:"checkBoxOn"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantTabController") as! RestaurantTabController
        print(seggests[indexPath.row].slug)
        
        if let restaurant = Singleton.currentUser().getStore()!.getRestaurantBySlugName(slug:seggests[indexPath.row].slug) {
            vc.restaurant = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    

}
