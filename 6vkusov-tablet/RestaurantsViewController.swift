//
//  RestaurantsViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/13/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, LoadJson {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var restaurantsFiltred = [Restaurant]()
    
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderResult: UILabel!
    @IBOutlet weak var newBtn: CheckBox!
    @IBOutlet weak var freeFoodBtn: CheckBox!
    @IBOutlet weak var promoBtn: CheckBox!
    @IBOutlet weak var saleBtn: CheckBox!
    
    
    var isFavorite = false
    private var restaurants = [Restaurant]()
    private var fullRestaurants = [Restaurant]()
    
    private var searchController:UISearchController!
    private var resultsController = RestaurantsTableViewController()
    private var slug:String!
    private var isFilterOpen = false
    
    private var isFilterFull : Bool = false
    {
        didSet
        {
            filterButton.image = isFilterFull ? UIImage(named: "filter_full") : UIImage(named: "filter_clear")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFavorite {
            restaurants = [Restaurant]()
            self.tableView.reloadData()
            let user = Singleton.currentUser().getUser()
            if user?.getStatus() == STATUS.REGISTRED {
                var dict = Dictionary<String, AnyObject>()
                dict["key"] = REST_URL.KEY.rawValue as AnyObject
                dict["session"] = user?.getProfile()?["session"] as AnyObject
                JsonHelperLoad.init(url: REST_URL.SF_FAVOURITES.rawValue, params: dict, act: self, sessionName: nil).startSession()
            }else{
                if let slugs = Singleton.currentUser().getStore()?.getAllSlugs() {
                    print(slugs)
                    restaurants = Singleton.currentUser().getStore()!.getFavoriteRestaurants(slugs: slugs)
                    self.tableView.reloadData()
                }
            }
        }else{
            restaurants = Singleton.currentUser().getStore()!.getRestaurants(slug: slug)
        }
        fullRestaurants = restaurants
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        initViews()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let request = obj {
            if let status = request["status"] as? String {
                if status == "successful" {
                    if let slugs = request["slugs"] as? [String] {
                        restaurants = Singleton.currentUser().getStore()!.getFavoriteRestaurants(slugs: slugs)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func sliderAction(_ sender: Any)
    {
        filterChanged()
        sliderResult.text = "до \(Int(slider.value)) руб."
    }
    
    @objc private func filterChanged()
    {
        isFilterFull = slider.value > 0.9 ||
            newBtn.isChecked ||
            freeFoodBtn.isChecked ||
            promoBtn.isChecked ||
            saleBtn.isChecked
        
        self.restaurants = self.fullRestaurants
        
        if slider.value > 0.0 {
            self.restaurants = self.restaurants.filter
                {
                    (restaurant:Restaurant)->Bool in
                    return restaurant.minimal_price < slider.value
            }
            
        }
        
        if newBtn.isChecked {
            self.restaurants = self.restaurants.filter
                {
                    (restaurant:Restaurant)->Bool in
                    return restaurant.isNew
            }
            
        }
        
        if freeFoodBtn.isChecked{
            self.restaurants = self.restaurants.filter
                {
                    (restaurant:Restaurant)->Bool in
                    return restaurant.isFreeFood
            }
        }
        
        if promoBtn.isChecked{
            self.restaurants = self.restaurants.filter
                {
                    (restaurant:Restaurant)->Bool in
                    return restaurant.isPromo
            }
        }
        
        
        if saleBtn.isChecked{
            self.restaurants = self.restaurants.filter
                {
                    (restaurant:Restaurant)->Bool in
                    return restaurant.isSale
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func initViews()
    {
        resultsController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsTableViewController") as! RestaurantsTableViewController
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        
        self.searchController.searchBar.placeholder = "Поиск ресторана"
        self.searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        self.searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = self.searchController.searchBar
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        newBtn.addTarget(self, action: #selector(filterChanged), for: UIControlEvents.touchUpInside)
        freeFoodBtn.addTarget(self, action: #selector(filterChanged), for: UIControlEvents.touchUpInside)
        promoBtn.addTarget(self, action: #selector(filterChanged), for: UIControlEvents.touchUpInside)
        saleBtn.addTarget(self, action: #selector(filterChanged), for: UIControlEvents.touchUpInside)
        slider.maximumValue = getRestaurantsMaximumDelivery()
        slider.minimumValue = 0.0
        slider.value = 0.0
    }
    
    func getRestaurantsMaximumDelivery() -> Float
    {
        var max = restaurants.count > 0 ? restaurants[0].minimal_price : 0
        for rest in restaurants {
            if max < rest.minimal_price{
                max = rest.minimal_price
            }
        }
        return max + 10
    }
    
    @IBAction func filterTapped(_ sender: Any)
    {
        self.heightTableViewConstraint.constant = isFilterOpen ? 0: -170
        isFilterOpen = !isFilterOpen
        UIView.animate(withDuration: 0.6) {self.view.layoutIfNeeded()}
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        self.restaurantsFiltred = self.restaurants.filter
            {
                (restaurant:Restaurant)->Bool in
                return restaurant.name.capitalized.contains(self.searchController.searchBar.text!.capitalized) ? true:false
        }
        self.resultsController.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  UIScreen.main.bounds.height/3.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableView == self.tableView ? self.restaurants.count : self.restaurantsFiltred.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurant_cell", for: indexPath) as! RestaurantTableViewCell
        let restaurant = tableView == self.tableView ? restaurants[indexPath.row] : restaurantsFiltred[indexPath.row]
        cell.name.text = restaurant.name
        cell.kichenType.text = restaurant.kitchens
        cell.deliveryPrice.text = "\(restaurant.minimal_price) руб"
        cell.deliveryTime.text = "\(restaurant.delivery_time) мин"
        cell.likeCounts.text = "\(restaurant.comments["likes"]!)"
        cell.dislikesCounts.text = "\(restaurant.comments["dislikes"]!)"
        cell.icon.sd_setImage(with: URL(string: restaurant.iconURL), placeholderImage: UIImage(named:"checkBoxOn"))
        return cell
    }
    
    func setType(slug: String)
    {
        self.slug =  slug
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = self.restaurants[indexPath.row]
        if self.searchController.isActive {
            self.searchController.dismiss(animated: true) { () -> Void in
                self.searchController.searchBar.text = ""
                self.searchController.searchBar.showsCancelButton = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantTabController") as! RestaurantTabController
                vc.restaurant = restaurant
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantTabController") as! RestaurantTabController
            vc.restaurant = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
