//
//  MessageController.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class MessageController: RCConversationListViewController, RCIMUserInfoDataSource{
    override func viewDidLoad() {
        
        self.title = "消息"
        RCIM.sharedRCIM().userInfoDataSource = self
        
        
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        
        
        let emptyLabel = UILabel(frame: CGRectMake(100,100,50,50))
        emptyLabel.text = "请在朋友页面发起会话"
        emptyLabel.textColor = UIColor.lightGrayColor()
        self.emptyConversationView = emptyLabel
        
        
        emptyLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-64)
        }
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue])

        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"] as! NSString
        var name = userDic!["name"] as! NSString
        if (name == "") {
            name = mePhone
        }
        
        let token = NSUserDefaults.standardUserDefaults().objectForKey("RC_TOKEN") as? String

        if (token == nil) {
            
            Alamofire.request(.GET, AppDelegate.baseURLString + "/getRongCloudToken", parameters: ["mePhone": mePhone, "name": name]).responseJSON { (response) -> Void in
                print(response.request)
                print(response.result.value)
                
                
                
                if (response.result.isSuccess) {
                    let code = response.result.value?.valueForKey("code") as! String
                    if(code == "200") {
                        let token = response.result.value?.valueForKey("result")?.valueForKey("token") as! String
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "RC_TOKEN")
                        RCIM.sharedRCIM().connectWithToken(token, success: { (userId) in
                            print("登陆成功。当前登录的用户ID：\(userId)")

                            }, error: { (status) in
                                let alertController = UIAlertController(title: "提示", message: "登陆的错误码为:\(status.rawValue)", preferredStyle: UIAlertControllerStyle.Alert)
                                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                NSUserDefaults.standardUserDefaults().removeObjectForKey("RC_TOKEN")
                            }, tokenIncorrect: { 
                                let alertController = UIAlertController(title: "提示", message: "Token已过期，请重新登录", preferredStyle: UIAlertControllerStyle.Alert)
                                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                NSUserDefaults.standardUserDefaults().removeObjectForKey("RC_TOKEN")
                        })
                    }

                } else {
                    let alertController = UIAlertController(title: "提示", message: response.result.error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        }
        
        

        
        
        RCIM.sharedRCIM().connectWithToken(token,
                                           success: { (userId) -> Void in
                                            print("登陆成功。当前登录的用户ID：\(userId)")
                                            self.refreshConversationTableViewIfNeeded()
            }, error: { (status) -> Void in
                
//                let alertController = UIAlertController(title: "提示", message: "登陆的错误码为:\(status.rawValue)", preferredStyle: UIAlertControllerStyle.Alert)
//                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("RC_TOKEN")
                
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                
                let alertController = UIAlertController(title: "提示", message: "Token已过期，请重新登录", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("RC_TOKEN")

                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.notifyUpdateUnreadMessageCount()
    }
    
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        //打开会话界面
        let chat = ChatController(conversationType: model.conversationType, targetId: model.targetId)
        chat.title = model.conversationTitle;
        chat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat, animated: true)
        self.notifyUpdateUnreadMessageCount()
        
    }
    
    
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        
        let x = arc4random() % 100;
        
        
        
        let parameters = [
            "mePhone": userId,
            "random":NSString(format: "%d", x)
            ]
        Alamofire.request(.POST, AppDelegate.baseURLString + "/login", parameters: parameters, encoding: .JSON).responseJSON { response in
            print(response.result.value)
            if response.result.isSuccess {
                let userDic = response.result.value as? NSDictionary
                if (userDic!["name"] as! String == "") {
                    completion?(RCUserInfo.init(userId: userId, name: userId, portrait: AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId))
                } else {
                    completion?(RCUserInfo.init(userId: userId, name: userDic!["name"] as? String, portrait: AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId))
                }
            } else {
                completion?(RCUserInfo.init(userId: userId, name: userId, portrait: nil))
            }
        }

        
    }
    

    
    func doReceiveMessage(title: NSNotification) {
        

    }
    
    
    override func notifyUpdateUnreadMessageCount() {
        self.updateBadgeValueForTabBarItem()
    }
    
    func updateBadgeValueForTabBarItem() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //需要长时间处理的代码
            dispatch_async(dispatch_get_main_queue(), {
                //需要主线程执行的代码
                let count = RCIMClient.sharedRCIMClient().getTotalUnreadCount()
                if (count > 0) {
                    self.navigationController?.tabBarItem.badgeValue = String(count)
                    UIApplication.sharedApplication().applicationIconBadgeNumber = Int(count)
                } else {
                    self.navigationController?.tabBarItem.badgeValue = nil
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0

                }
            })
        })
    }
    
}