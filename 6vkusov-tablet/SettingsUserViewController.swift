//
//  SettingsUserViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/15/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class SettingsUserViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var settings = [Dictionary<String,Any>]()
    private var heightCell:CGFloat = 0
    var button:UIBarButtonItem?
    func gg(){
        print("gg")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Настройки"
        self.tabBarController?.navigationItem.rightBarButtonItem = button
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action:#selector(gg))
        heightCell = UIScreen.main.bounds.height/4
        settings = [
            [
                "type":"check",
                "name":"Предпочтения по кухне",
                "items": [
                    [
                        "name":"Азиатская",
                        "value":false
                    ],
                    [
                        "name":"Грузинская",
                        "value":false
                    ],
                    [
                        "name":"Европейская",
                        "value":false
                    ],
                    [
                        "name":"Белорусская",
                        "value":false
                    ],
                    [
                        "name":"Итальянская",
                        "value":false
                    ],
                    [
                        "name":"Итальянская",
                        "value":false
                    ],
                    [
                        "name":"Американская",
                        "value":false
                    ],
                    [
                        "name":"Японская",
                        "value":false
                    ],
                    [
                        "name":"Китайская",
                        "value":false
                    ]
            
                ]
            ],
            [
                "type":"check",
                "name":"Любимые блюда",
                "items": [
                    [
                        "name":"Пироги",
                        "value":false
                    ],
                    [
                        "name":"Супы",
                        "value":false
                    ],
                    [
                        "name":"Плов",
                        "value":false
                    ],
                    [
                        "name":"Бургеры",
                        "value":false
                    ],
                    [
                        "name":"Суши",
                        "value":false
                    ],
                    [
                        "name":"Паста",
                        "value":false
                    ],
                    [
                        "name":"Салаты",
                        "value":false
                    ],
                    [
                        "name":"Стейки",
                        "value":false
                    ],
                    [
                        "name":"Пицца",
                        "value":false
                    ],
                    [
                        "name":"Шаурма",
                        "value":false
                    ]
                    
                ]
            ],
            [
                "type":"radio",
                "name":"Как часто вы делаете закказ",
                "items": [
                    [
                        "name":"Каждый день",
                        "value":false
                    ],
                    [
                        "name":"Один раз в неделю",
                        "value":false
                    ],
                    [
                        "name":"Один раз в месяц",
                        "value":false
                    ],
                    [
                        "name":"Несколько раз в неделю",
                        "value":false
                    ],
                    [
                        "name":"Несколько раз в месяц",
                        "value":false
                    ],
                    [
                        "name":"Как получится",
                        "value":false
                    ]
                ]
            ],
            [
                "type":"radio",
                "name":"Ваш средний заказ",
                "items": [
                    [
                        "name":"Минимальная сумма доставки",
                        "value":false
                    ],
                    [
                        "name":"40-60 руб",
                        "value":false
                    ],
                    [
                        "name":"более 100 руб",
                        "value":false
                    ],
                    [
                        "name":"20-40 руб",
                        "value":false
                    ],
                    [
                        "name":"60-100 руб",
                        "value":false
                    ]
                ]
            ],
            [
                "type":"check",
                "name":"От куда вы узнали о сервисе",
                "items": [
                    [
                        "name":"Через поисковик",
                        "value":false
                    ],
                    [
                        "name":"Телевидение",
                        "value":false
                    ],
                    [
                        "name":"Буклеты",
                        "value":false
                    ],
                    [
                        "name":"Наружная реклама",
                        "value":false
                    ],
                    [
                        "name":"Соцсети",
                        "value":false
                    ],
                    [
                        "name":"Брошюры",
                        "value":false
                    ],
                    [
                        "name":"Радио",
                        "value":false
                    ],
                    [
                        "name":"Контекстная реклама",
                        "value":false
                    ]
                ]
            ]
        ]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Персональные данные"
        }else{
             return settings[section-1]["name"] as? String
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            let items = settings[section-1]["items"] as! [Dictionary<String,Any>]
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell") as! UserTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell")
            let items = settings[indexPath.section - 1]["items"] as! [Dictionary<String,Any>]
            let item = items[indexPath.row]
            if item["value"] as! Bool == true{
                cell!.accessoryType = .checkmark
            }
            else{
                cell!.accessoryType = .none
            }
            cell?.textLabel?.text = item["name"] as? String
            return cell!

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let type = settings[indexPath.section - 1]["type"] as? String
            var items = settings[indexPath.section - 1]["items"] as! [Dictionary<String,Any>]
            var item = items[indexPath.row]
            let value = item["value"] as! Bool
            
            if(type == "check"){
                if !value {
                    items[indexPath.row]["value"] = true
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.accessoryType = .checkmark
                    }
                }else{
                    items[indexPath.row]["value"] = false
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.accessoryType = .none
                    }
                }
            }
            print(settings)
        }
    }
    
        

}
