//
//  ViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/22/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var lunchscreen: UIImageView!
    @IBOutlet weak var generalMenu: UIView!
    @IBOutlet weak var registerMenu: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoMenu: UIImageView!
    
    private let singleton = Singleton.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        log(logMessage: "MainViewController Loading ...")
        singleton.initStore(vc: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lunchscreen.isHidden = true
        generalMenu.isHidden = singleton.getUser()?.getStatus() != STATUS.GENERAL
        registerMenu.isHidden = singleton.getUser()?.getStatus() != STATUS.REGISTRED
        
        if singleton.getUser()?.getStatus() == STATUS.GENERAL {
            logoMenu.image = UIImage(named:"user")
            loginButton.setTitle("Войти", for: UIControlState.normal)
            loginButton.setTitle("Войти", for: UIControlState.selected)
            loginButton.setTitle("Войти", for: UIControlState.highlighted)
        }else{
            let userData = singleton.getUser()?.getProfile()
            let firstName = userData?["firstName"] as? String
            
            loginButton.setTitle(firstName, for: UIControlState.normal)
            loginButton.setTitle(firstName, for: UIControlState.selected)
            loginButton.setTitle(firstName, for: UIControlState.highlighted)
            
            let img_path = userData?["img_path"] as! String
            if let avatar = userData?["avatar"] as? String {
                let url = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + avatar
                logoMenu.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"checkBoxOn"))
            }

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileOrLoginPressed(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTabViewController")
        
        //self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        singleton.getUser()?.getStatus() == STATUS.GENERAL ? self.navigationController?.pushViewController(loginViewController!, animated: true) : self.navigationController?.pushViewController(profileViewController!, animated: true)
    }
    
    @IBAction func promoViewControllerPressed(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PromoTabController") as! PromoTabController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    public func loadComplete(){
        log(logMessage: "Complete Load")
        let categoriesViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
        self.navigationController?.pushViewController(categoriesViewController!, animated: true)
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
            let store = self.singleton.getStore()
            store?.clearDataStorage(key: (store?.APP_PROFILE)!)
            self.lunchscreen.isHidden = false
            self.singleton.initStore(vc: self)
        }))
        logoutAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Отмена выхода")
        }))
        present(logoutAlert, animated: true, completion: nil)
    }

    @IBAction func favoritRestsPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        vc.setType(slug: "pizza")
        vc.isFavorite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

