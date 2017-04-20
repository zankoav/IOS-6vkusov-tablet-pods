//
//  PromoViewControllerTableViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class PromoTableViewController: UITableViewController {
    
    var array = [Promo]()
    let height = UIScreen.main.bounds.height/2
    var indexVC:Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var title = ["Еда","Техника","Подписки","Софт", "Игры"]
        self.tabBarController?.title = title[indexVC]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexVC = (self.tabBarController?.viewControllers?.index(of: self))!
        switch(indexVC) {
            case 0:
                array = [
                    ProductPromo(restName:"Три повара", preoductDesc: "вес: 217 г , 8 шт.",bonus: "1000", name: "БОНИТО", url: "/uploads/img/food/58885e5010f14.png", slug: "osushi"),
                    ProductPromo(restName:"Chixx", preoductDesc: "вес: 700 ",bonus: "800", name: "МАЙАМИ", url: "/uploads/img/food/589dd07fbfe7d.png", slug: "osushi"),
                    ProductPromo(restName:"Pizzamania", preoductDesc: "вес: 360 , размер: 32 см, на тонком тесте",bonus: "900", name: "ЧЕБУРЕКИ С СЫРОМ И ЗЕЛЕНЬЮ", url: "/uploads/img/food/588862777312c.png", slug: "osushi"),
                    ProductPromo(restName:"PizzaTempo", preoductDesc: "вес: 750",bonus: "1200", name: "ПИЦЦА 'МАРГАРИТА'", url: "/uploads/img/food/58c8f0b615ca7.png", slug: "osushi")
                ]
            break
            case 1:
                array = [
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "400", name: "Машина", url: "/uploads/img/good/587ccce4e191e.png", slug: "osushi"),
                    Promo(bonus: "30043", name: "Телефон", url: "/uploads/img/good/587ccee40b02c.png", slug: "osushi"),
                    Promo(bonus: "23235235", name: "Ноутбук", url: "/uploads/img/good/587cefbeaeb8e.png", slug: "osushi"),
                    Promo(bonus: "23523", name: "Мячик", url: "/uploads/img/good/587cf40836c6d.png", slug: "osushi"),
                    Promo(bonus: "235", name: "Компьютер", url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
                    Promo(bonus: "23535", name: "Флэшка", url: "/uploads/img/good/587cf0f01b612.png", slug: "osushi")
                ]
            break
            case 2:
                array = [
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi")
                ]
            break
            case 3:
                array = [
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "400", name: "Машина", url: "/uploads/img/good/587ccce4e191e.png", slug: "osushi"),
                    Promo(bonus: "30043", name: "Телефон", url: "/uploads/img/good/587ccee40b02c.png", slug: "osushi"),
                    Promo(bonus: "23235235", name: "Ноутбук", url: "/uploads/img/good/587cefbeaeb8e.png", slug: "osushi"),
                    Promo(bonus: "23523", name: "Мячик", url: "/uploads/img/good/587cf40836c6d.png", slug: "osushi"),
                    Promo(bonus: "235", name: "Компьютер", url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
                    Promo(bonus: "23535", name: "Флэшка", url: "/uploads/img/good/587cf0f01b612.png", slug: "osushi")
                ]
            break
            case 4:
                array = [
                    Promo(bonus: "100010", name: "Телескоп", url: "/uploads/img/good/587ccd815ab77.png", slug: "osushi"),
                    Promo(bonus: "400", name: "Машина", url: "/uploads/img/good/587ccce4e191e.png", slug: "osushi"),
                    Promo(bonus: "30043", name: "Телефон", url: "/uploads/img/good/587ccee40b02c.png", slug: "osushi"),
                    Promo(bonus: "23235235", name: "Ноутбук", url: "/uploads/img/good/587cefbeaeb8e.png", slug: "osushi"),
                    Promo(bonus: "23523", name: "Мячик", url: "/uploads/img/good/587cf40836c6d.png", slug: "osushi"),
                    Promo(bonus: "235", name: "Компьютер", url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
                    Promo(bonus: "23535", name: "Флэшка", url: "/uploads/img/good/587cf0f01b612.png", slug: "osushi")
                ]
            break
            default:break
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexVC == 0 {
            return height*1.2
        }else {
            return height
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexVC == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "product_promo_cell", for: indexPath) as! ProductPromoTableViewCell
            let promo = array[indexPath.row]  as! ProductPromo
            cell.restName.text = promo.restName
            cell.desc.text = promo.preoductDesc + " баллов"
            cell.bonus.text = promo.bonus + " баллов"
            cell.name.text = promo.name
            cell.icon.sd_setImage(with: URL(string: promo.iconURL), placeholderImage: UIImage(named:"like"))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "promo_cell", for: indexPath) as! PromoTableViewCell
            let promo = array[indexPath.row]
            cell.bonus.text = promo.bonus + " баллов"
            cell.name.text = promo.name
            cell.icon.sd_setImage(with: URL(string: promo.iconURL), placeholderImage: UIImage(named:"like"))
            return cell

        }
        
    }


}
