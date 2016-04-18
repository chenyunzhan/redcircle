//
//  AppDelegate.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCIMReceiveMessageDelegate{
    
    
//    static let baseURLString = "http://localhost:8080"
    static let baseURLString = "http://redcircle.tiger.mopaasapp.com"
//    static let baseURLString = "http://192.168.1.108:8080"


    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.backgroundColor = UIColor.lightGrayColor()
        let userInfo = NSUserDefaults.standardUserDefaults().valueForKey("USER_INFO") as? NSDictionary
        if userInfo == nil {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            self.window?.rootViewController = loginNavController
//            self.presentViewController(loginController, animated: true, completion: { () -> Void in
//                
//            })
        } else {
            let homeController = HomeController()
            self.window?.rootViewController = homeController
        }
        
        
        
        //推送处理1
        if #available(iOS 8.0, *) {
            //注册推送,用于iOS8以上系统
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(forTypes:[.Alert, .Badge, .Sound], categories: nil))
        } else {
            //注册推送,用于iOS8以下系统
            application.registerForRemoteNotificationTypes([.Badge, .Alert, .Sound])
        }
        
        
        SMSSDK.registerApp("111412781a7c4", withSecret: "81008993f3de84d463ccd91cf4bb7509")
        
        RCIM.sharedRCIM().initWithAppKey("qf3d5gbj3ufqh")
        
        //设置消息接收的监听
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveMessageNotification:", name: RCKitDispatchMessageNotification, object: nil)
        
        
//        RCIM.sharedRCIM().connectWithToken("Keyqf3d5gbj3ufqh",
//            success: { (userId) -> Void in
//                print("登陆成功。当前登录的用户ID：\(userId)")
//            }, error: { (status) -> Void in
//                print("登陆的错误码为:\(status.rawValue)")
//            }, tokenIncorrect: {
//                //token过期或者不正确。
//                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                print("token错误")
//        })
        
        
        return true
    }
    
    //推送处理2
    @available(iOS 8.0, *)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //注册推送,用于iOS8以上系统
        application.registerForRemoteNotifications()
    }
    
    //推送处理3
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var rcDevicetoken = deviceToken.description
        rcDevicetoken = rcDevicetoken.stringByReplacingOccurrencesOfString("<", withString: "")
        rcDevicetoken = rcDevicetoken.stringByReplacingOccurrencesOfString(">", withString: "")
        rcDevicetoken = rcDevicetoken.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        RCIMClient.sharedRCIMClient().setDeviceToken(rcDevicetoken)
    }
    
    
    //推送处理4
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //远程推送的userInfo内容格式请参考官网文档
        //http://www.rongcloud.cn/docs/ios.html#App_接收的消息推送格式
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //本地通知
    }
    
    //监听消息接收
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        
//        let count = RCIMClient.sharedRCIMClient().getTotalUnreadCount()
//        UIApplication.sharedApplication().applicationIconBadgeNumber = Int(count)
//        
//        NSNotificationCenter.defaultCenter().postNotificationName("RECIEVE_NEW_MESSAGE", object: "111111")
//        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            //需要长时间处理的代码
//            dispatch_async(dispatch_get_main_queue(), {
//                //需要主线程执行的代码
//                let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
//
//                if (userDic != nil) {
//                    let homeController = self.window?.rootViewController as! UITabBarController
//                    let messageNavController = homeController.viewControllers![0] as! UINavigationController
//                    messageNavController.tabBarItem.badgeValue = String(count)
//                }
//
//            })
//        })
//        print(count)
        
        if (left != 0) {
            print("收到一条消息，当前的接收队列中还剩余\(left)条消息未接收，您可以等待left为0时再刷新UI以提高性能")
        } else {
            print("收到一条消息")
        }
    }
    
    func didReceiveMessageNotification(notification: NSNotification) {
        let message = notification.object
        if (message?.messageDirection == .MessageDirection_RECEIVE) {
            UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        }
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

