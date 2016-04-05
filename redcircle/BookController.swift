//
//  BookController.swift
//  redcircle
//
//  Created by zhan on 16/4/5.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class BookController: UITableViewController {
    override func viewDidLoad() {
        let mePhone = NSUserDefaults.standardUserDefaults().objectForKey("ME_PHONE")
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getFriends", parameters: ["mePhone": mePhone!]).responseJSON { (response) -> Void in
            print(response.result.value)
            print(response.request)
        }
    }
}