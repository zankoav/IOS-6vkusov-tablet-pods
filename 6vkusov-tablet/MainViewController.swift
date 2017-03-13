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
            let email = singleton.getUser()?.getProfile()?["email"] as? String
            loginButton.setTitle(email, for: UIControlState.normal)
            loginButton.setTitle(email, for: UIControlState.selected)
            loginButton.setTitle(email, for: UIControlState.highlighted)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileOrLoginPressed(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        
        singleton.getUser()?.getStatus() == STATUS.GENERAL ?
            self.navigationController?.pushViewController(loginViewController!, animated: true):
            self.navigationController?.pushViewController(profileViewController!, animated: true)
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

}

