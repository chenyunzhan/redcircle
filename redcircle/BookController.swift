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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        
        self.title = "朋友"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加朋友", style: .Done, target: self, action: #selector(addRootFriend));
        self.tableView.registerClass(BookTableViewCell.classForCoder(), forCellReuseIdentifier: BookTableViewCell.cellID())

        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"]
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getFriends", parameters: ["mePhone": mePhone!!]).responseJSON { (response) -> Void in
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
        let  cell = tableView.dequeueReusableCellWithIdentifier(BookTableViewCell.cellID(), forIndexPath: indexPath) as! BookTableViewCell
        let friends = self.tableData[indexPath.section]
        let ffriend = friends["ffriend"].arrayValue
        let friend = ffriend[indexPath.row]
        cell.cellForModel(friend)
//        let ffriend = friends["ffriend"].arrayValue
//        let friend = ffriend[indexPath.row]
//        
//        
//        let cell = UITableViewCell()


        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let friends = self.tableData[section]
        let friend = friends["friend"]
        
        
        let name = friend["name"].string
        if name != "" {
            return friend["name"].string!+"的朋友圈"
        } else {
            return friend["friendPhone"].string!+"的朋友圈"
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let friends = self.tableData[indexPath.section]
        let ffriend = friends["ffriend"].arrayValue
        let friend = ffriend[indexPath.row]
        
        
        //新建一个聊天会话View Controller对象
        let chat = ChatController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = friend["mePhone"].string
        //设置聊天会话界面要显示的标题
        if friend["name"].string != "" {
            chat.title = friend["name"].string
        } else {
            chat.title = friend["mePhone"].string
        }
        //显示聊天会话界面
        chat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat, animated: true)
    }
    
    
    func addRootFriend() -> Void {
        let addFriendController = AddFriendController()
        addFriendController.hidesBottomBarWhenPushed = true
        addFriendController.initWithClosure(someFunctionThatTakesAClosure)
        self.navigationController?.pushViewController(addFriendController, animated: true)
    }
    
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }
    
    
    
}