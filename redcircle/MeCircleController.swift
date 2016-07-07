//
//  MeCircleController.swift
//  redcircle
//
//  Created by zhan on 16/7/7.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Alamofire
import SwiftyJSON


class MeCircleController:  UITableViewController  {
    
    var circleLevel: String?
    var startNo: String?
    var mePhone: String?
    var tableData: [JSON] = []

    
    override func viewDidLoad() {
        
        
        startNo = "0"
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        mePhone = userDic!["mePhone"] as? String
        
        self.tableView.registerClass(ArticleTableViewCell.classForCoder(), forCellReuseIdentifier: ArticleTableViewCell.cellID())

        
        let parameters = [
            "mePhone": mePhone!,
            "circleLevel": circleLevel!,
            "startNo": startNo!
        ]
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getArticles", parameters: parameters).responseJSON { response in
            let tableData = JSON(response.result.value!).arrayValue
            self.tableData = tableData
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let article = self.tableData[indexPath.row]
        
        let  cell = tableView.dequeueReusableCellWithIdentifier(ArticleTableViewCell.cellID(), forIndexPath: indexPath) as! ArticleTableViewCell

        cell.cellForModel(article)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let article = self.tableData[indexPath.row]
        
        return ArticleTableViewCell.heightForModel(article)
    }
}