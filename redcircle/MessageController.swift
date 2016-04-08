//
//  MessageController.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class MessageController: RCConversationListViewController {
    override func viewDidLoad() {
        
        self.title = "消息"
        
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        
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
        let mePhone = userDic!["mePhone"]
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getRongCloudToken", parameters: ["mePhone": mePhone!!]).responseJSON { (response) -> Void in
            print(response.request)
            print(response.result.value)
            let code = response.result.value?.valueForKey("code") as! String
            if (response.result.isSuccess && code == "200") {
                
                let token = response.result.value?.valueForKey("result")?.valueForKey("token") as! String

                RCIM.sharedRCIM().connectWithToken(token,
                    success: { (userId) -> Void in
                        print("登陆成功。当前登录的用户ID：\(userId)")
                    }, error: { (status) -> Void in
                        print("登陆的错误码为:\(status.rawValue)")
                    }, tokenIncorrect: {
                        //token过期或者不正确。
                        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                        print("token错误")
                })
            }
            
            
        }
    }
}