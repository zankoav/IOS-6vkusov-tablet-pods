//
//  RestaurantCommentsViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantCommentsViewController: UITableViewController, LoadJson
{

    var comments = [Comment]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        let tabController = self.tabBarController as! RestaurantTabController
        let slug = tabController.restaurant.slug
        JsonHelperLoad(url: REST_URL.SF_COMMENTS.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject, "slug":slug as AnyObject], act: self, sessionName: nil).startSession()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.icon.sd_setImage(with: URL(string: comment.userIconUrl!), placeholderImage: UIImage(named: "userComment"))
        cell.like.image = comment.userLike == 1 ? UIImage(named: "like") : UIImage(named: "dislike")
        cell.name.text = comment.uerName
        cell.textCommnet.text = comment.text
        cell.time.text = comment.created
        return cell
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let array = obj?["comments"] as? [Dictionary<String,AnyObject>] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            for ar in array {
                var img_path = "\(REST_URL.SF_DOMAIN.rawValue)/\(obj?["img_path"] as! String)/"
                let like = ar["type"] as! Int
                let text = ar["text"] as! String
                let userName = ar["user"] as! String
                
                
                let date = Date(timeIntervalSince1970: TimeInterval(ar["date_time"] as! Int))
                let created = dateFormatter.string(from: date)
                
                if let userLogo = ar["avatarFile"] as? String {
                    img_path += userLogo
                }
                let comment = Comment(url: img_path, created: created, name: userName, like: like, text: text)
                self.comments.append(comment)
            }
            self.tableView.reloadData()
        }
    }
}
