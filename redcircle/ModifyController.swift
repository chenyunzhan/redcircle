//
//  ModifyController.swift
//  redcircle
//
//  Created by zhan on 16/4/7.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class ModifyController: UIViewController {
    
    var subTitle: String = ""
    var textField: UITextField?
    
    override func viewDidLoad() {
        
        self.title = "修改" + self.subTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修改", style: UIBarButtonItemStyle.Done, target: self, action: "doModifyAction");
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textField = UITextField()
        textField.placeholder = "请输入新的" + self.subTitle
        self.view.addSubview(textField)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.redColor()
        self.view .addSubview(lineView)
        
        lineView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(textField.snp_bottom)
            make.right.equalTo(textField)
            make.left.equalTo(textField)
            make.height.equalTo(1)
        }
        
        textField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(80)
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
    }
    
    func doModifyAction() {
        
        var userParam = "name"
        
        if self.subTitle == "性别" {
            userParam = "sex"
        }
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"]
        
        let parameters = [
            userParam : self.textField?.text as! AnyObject,
            "mePhone"   : mePhone as! String
        ]
        

        Alamofire.request(.POST, AppDelegate.baseURLString + "/modify", parameters: parameters, encoding: .JSON).responseJSON { response in
            if response.result.isSuccess {
                
                
            }
        }
    }
    
}