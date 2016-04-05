//
//  BookController.swift
//  redcircle
//
//  Created by zhan on 16/4/5.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class BookController: UITableViewController {
    
    var tableData: [JSON] = []
    
    override func viewDidLoad() {
        let mePhone = NSUserDefaults.standardUserDefaults().objectForKey("ME_PHONE")
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getFriends", parameters: ["mePhone": mePhone!]).responseJSON { (response) -> Void in
            print(response.result.value)
            let tableData = JSON(response.result.value!).arrayValue
            self.tableData = tableData
            
            self.tableView.reloadData()
            print(response.request)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friends = self.tableData[section]
        let ffriend = friends["ffriend"].arrayValue
        return ffriend.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friends = self.tableData[indexPath.section]
        let ffriend = friends["ffriend"].arrayValue
        let friend = ffriend[indexPath.row]
        
        
        let cell = UITableViewCell()
        cell.textLabel?.text = friend["friendPhone"].string
        return cell
    }
}