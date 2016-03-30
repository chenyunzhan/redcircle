//
//  LoginController.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true
        
        let registerButton = UIButton()
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(registerButton)
        self.view.backgroundColor = UIColor.whiteColor()
        
        registerButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        registerButton.addTarget(self, action: "gotoRegisterController", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
    }
    
    
    func gotoRegisterController() {
        let registerController = RegisterController()
        self.navigationController?.pushViewController(registerController, animated: true)
    }
    
}