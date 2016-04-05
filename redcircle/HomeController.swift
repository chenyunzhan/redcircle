//
//  ViewController.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let messageController = MessageController()
        let meController = MeController()
        let bookController = BookController()
        
        let messageNavController = UINavigationController(rootViewController: messageController)
        let meNavController = UINavigationController(rootViewController: meController)
        let bookNavController = UINavigationController(rootViewController: bookController)
        
        messageNavController.tabBarItem = UITabBarItem(title: "消息", image: UIImage.fontAwesomeIconWithName(.Comment, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), tag: 100)
        bookNavController.tabBarItem = UITabBarItem(title: "朋友", image: UIImage.fontAwesomeIconWithName(.Users, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), tag: 101)
        meNavController.tabBarItem = UITabBarItem(title: "我的", image: UIImage.fontAwesomeIconWithName(.User, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30)), tag: 102)

        self.viewControllers = [messageNavController,bookNavController,meNavController]
        


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

