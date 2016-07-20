//
//  UserDetailController.swift
//  redcircle
//
//  Created by zhan on 16/7/6.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyButton


class UserDetailController: UITableViewController {
    
    var mePhone: String?
    var friendPhone: String?
    var userDic: NSDictionary?

    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "详细资料";
        
        
        let footerView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 150))
        footerView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footerView
        
    
        
        
        let dialMobileButton = SwiftyButton(frame: CGRect(x: 20,y: 20,width: footerView.frame.size.width-40,height: 48))
        dialMobileButton.buttonColor = UIColor.redColor()
        dialMobileButton.highlightedColor = UIColor.orangeColor()
        dialMobileButton.shadowHeight = 0
        dialMobileButton.cornerRadius = 5
        
        let sendMessageButton = SwiftyButton(frame: CGRect(x: 20,y: 88,width: footerView.frame.size.width-40,height: 48))
        sendMessageButton.buttonColor = UIColor.redColor()
        sendMessageButton.highlightedColor = UIColor.orangeColor()
        sendMessageButton.shadowHeight = 0
        sendMessageButton.cornerRadius = 5
        
        
        dialMobileButton.setTitle("打电话", forState: .Normal)
        sendMessageButton.setTitle("发信息", forState: .Normal)
        
        
        dialMobileButton.addTarget(self, action: #selector(UserDetailController.dialMobileAction), forControlEvents: .TouchUpInside)
        
        sendMessageButton.addTarget(self, action: #selector(UserDetailController.sendMessageAction), forControlEvents: .TouchUpInside)
        
        footerView.addSubview(dialMobileButton)
        footerView.addSubview(sendMessageButton)
        
        let parameters = [
            "mePhone": mePhone!,
            "friendPhone": friendPhone!
        ]
        Alamofire.request(.POST, AppDelegate.baseURLString + "/userDetail", parameters: parameters, encoding: .JSON).responseJSON { response in
            if response.result.isSuccess {
                let userDic = response.result.value as? NSDictionary
                self.userDic = userDic
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let photoImageView = UIImageView()
        let nameLabel = UILabel()
        let sexLabel = UILabel()
        let phoneLabel = UILabel()
        
        if indexPath.section == 0 {
            
            cell.contentView.addSubview(photoImageView)
            cell.contentView.addSubview(nameLabel)
            cell.contentView.addSubview(sexLabel)
            cell.contentView.addSubview(phoneLabel)
            
            photoImageView.snp_makeConstraints(closure: { (make) in
                make.leading.equalTo(20)
                make.top.equalTo(8)
                make.bottom.equalTo(-8)
                make.width.equalTo(80)
            })
            
            nameLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(photoImageView.snp_right).offset(8)
                make.top.equalTo(8)
            })
            
            sexLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(photoImageView.snp_right).offset(8)
                make.centerY.equalTo(cell.contentView)
            })
            
            phoneLabel.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(photoImageView.snp_right).offset(8)
                make.bottom.equalTo(-8)
            })
        } else {
            cell.accessoryType = .DisclosureIndicator
        }
        
        
        if (self.userDic != nil) {
            if(indexPath.section == 0) {
                let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (self.userDic!["me_phone"] as! String + "&type=thumbnail")
                Alamofire.request(.GET, imageUrl).response { (request, response, data, error) in
                    photoImageView.image = UIImage(data: data!, scale:1)
                }
                
                
                nameLabel.text = self.userDic!["name"] as? String
                sexLabel.text = self.userDic!["sex"] as? String
                phoneLabel.text = self.userDic!["me_phone"] as? String
            } else if(indexPath.section == 1) {
                cell.imageView?.image = UIImage.fontAwesomeIconWithName(.Photo, textColor: UIColor.lightGrayColor(), size: CGSizeMake(20, 20))
                cell.textLabel?.text = "查看相册"
            } else if(indexPath.section == 2) {
                cell.imageView?.image = UIImage.fontAwesomeIconWithName(.Heart, textColor: UIColor.lightGrayColor(), size: CGSizeMake(20, 20))
                cell.textLabel?.text = self.userDic!["recommend_language"] as? String
            }
        }
        

        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 96
        }
        return 44
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            let modifyRelation = ModifyRelationController()
            modifyRelation.friendPhone = friendPhone
            modifyRelation.mePhone = mePhone
            modifyRelation.initWithClosure(someFunctionThatTakesAClosure)
            modifyRelation.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(modifyRelation, animated: true)
        } else if indexPath.section == 1 {
            let meCircle = MeCircleController()
            meCircle.circleLevel = "0"
            meCircle.mePhone = friendPhone
            meCircle.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(meCircle, animated: true)
        }
    }
    
    func dialMobileAction () {

        if (self.userDic != nil) {
            let phoneNumber = self.userDic!["me_phone"] as! String
//            let callWebView = UIWebView()
//            let phoneURL = NSURL(fileURLWithPath: "tel:" + phoneNumber)
//            
//            callWebView.loadRequest(NSURLRequest(URL: phoneURL))
//            
//            self.tableView.addSubview(callWebView)
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:" + phoneNumber)!)
        }

    }
    
    
    func sendMessageAction () {
        //新建一个聊天会话View Controller对象
        let chat = ChatController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.userDic!["me_phone"] as! String
        //设置聊天会话界面要显示的标题
        if self.userDic!["name"] as! String != "" {
            chat.title = self.userDic!["name"] as? String
        } else {
            chat.title = self.userDic!["me_phone"] as? String
        }
        //显示聊天会话界面
        chat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat, animated: true)
        
    }
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }
}
