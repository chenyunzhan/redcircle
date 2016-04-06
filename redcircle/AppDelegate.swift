//
//  AppDelegate.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    static let baseURLString = "http://192.168.1.103:8080"

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
        
        
        
        
        SMSSDK.registerApp("111412781a7c4", withSecret: "81008993f3de84d463ccd91cf4bb7509")
        
        RCIM.sharedRCIM().initWithAppKey("qf3d5gbj3ufqh")
        
        
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

