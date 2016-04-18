//
//  FriendController.swift
//  redcircle
//
//  Created by zhan on 16/3/30.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire


class FriendController: UITableViewController {
    
    var friendArray: NSMutableArray?
    var verifyFriendArray: [String]?
    var meInfo: NSDictionary?
    var verifyButtonStatusArray: NSMutableArray?
    
    override func viewDidLoad() {
        self.title = "朋友信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成注册", style: UIBarButtonItemStyle.Done, target: self, action: "doResigterAction")
        let footerButton = UIButton()
        footerButton.setTitle("添加一个朋友", forState: UIControlState.Normal)
        footerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        footerButton.frame = CGRectMake(0, 0, 0, 40)
        footerButton.addTarget(self, action: "addFriendAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.tableView.tableFooterView = footerButton
        
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
        self.friendArray = [NSMutableDictionary(),NSMutableDictionary()]
        self.verifyFriendArray = []
        self.verifyButtonStatusArray = [VerifyButtonStatus(),VerifyButtonStatus()]
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.friendArray?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(indexPath)
        
        let cell = UITableViewCell()
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = String(format: "请输入您朋友%d的手机号", indexPath.section+1)

        cell.contentView.addSubview(userPhoneTextField)
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        cell.contentView.addSubview(verifyCodeTextField)
        
        let verifyCodeButton = SwiftyButton()
        verifyCodeButton.tag = indexPath.section
        verifyCodeButton.highlightedColor = UIColor.orangeColor()
        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        verifyCodeButton.addTarget(self, action: "getVerifyCode:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(verifyCodeButton)
        
        
        let userPhoneLineView = UIView()
        userPhoneLineView.backgroundColor = UIColor.redColor()
        cell.contentView .addSubview(userPhoneLineView)
        
        let verifyCodeLineView = UIView()
        verifyCodeLineView.backgroundColor = UIColor.redColor()
        cell.contentView.addSubview(verifyCodeLineView)
        
        
        
        let friendDic = self.friendArray?[indexPath.section] as! NSMutableDictionary
        userPhoneTextField.text = friendDic["phone_text"] as? String
        verifyCodeTextField.text = friendDic["verify_code_text"] as? String
        
        let verifyButtonStatus = self.verifyButtonStatusArray?[indexPath.section] as! VerifyButtonStatus
        verifyButtonStatus.sendButton = verifyCodeButton
        if (verifyButtonStatus.isCounting) {
            verifyCodeButton.buttonColor  = UIColor.grayColor()
        } else {
            verifyCodeButton.buttonColor = UIColor.redColor()
            verifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        }

        
        
        userPhoneTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cell.contentView).offset(8)
            make.right.equalTo(cell.contentView).offset(-20)
            make.left.equalTo(cell.contentView).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp_bottom).offset(8)
            make.left.equalTo(cell.contentView).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp_bottom).offset(8)
            make.right.equalTo(cell.contentView).offset(-20)
            make.left.equalTo(verifyCodeTextField.snp_right).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
        
        
        userPhoneLineView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(userPhoneTextField.snp_bottom)
            make.right.equalTo(userPhoneTextField)
            make.left.equalTo(userPhoneTextField)
            make.height.equalTo(1)
        }
        
        
        verifyCodeLineView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(verifyCodeTextField.snp_bottom)
            make.right.equalTo(verifyCodeTextField)
            make.left.equalTo(verifyCodeTextField)
            make.height.equalTo(1)
        }
        
        
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    
    func addFriendAction() {
        for var index = 0; index < self.friendArray?.count; ++index {
            let indexPath = NSIndexPath(forRow: 0, inSection: index)

            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            if (cell != nil) {
                let userPhoneTextField = cell?.contentView.subviews[0] as? UITextField
                let verifyCodeTextField = cell?.contentView.subviews[1] as? UITextField
                let friendDic = self.friendArray![index]
                friendDic.setObject(userPhoneTextField?.text, forKey: "phone_text")
                friendDic.setObject(verifyCodeTextField?.text, forKey: "verify_code_text")
            }
        }
        
        
        
        
        self.friendArray?.addObject(NSMutableDictionary())
        self.verifyButtonStatusArray?.addObject(VerifyButtonStatus())
        self.tableView.reloadData()
    }
    
    
    func doResigterAction() {
        
        self.verifyFriendArray = []

        
        for var index = 0; index < self.friendArray?.count; ++index {
            let indexPath = NSIndexPath(forRow: 0, inSection: index)
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            if (cell != nil) {
                let userPhoneTextField = cell?.contentView.subviews[0] as? UITextField
                let verifyCodeTextField = cell?.contentView.subviews[1] as? UITextField
                let friendDic = self.friendArray![index]
                friendDic.setObject(userPhoneTextField?.text, forKey: "phone_text")
                friendDic.setObject(verifyCodeTextField?.text, forKey: "verify_code_text")
            }

        }
        
        
        
        
        let group = dispatch_group_create();
        
        for friendDic in self.friendArray! {
            print(friendDic)
            
            
            
            if friendDic.count > 0 {
                
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_group_async(group, queue, { () -> Void in

                    SMSSDK.commitVerificationCode(friendDic["verify_code_text"] as? String, phoneNumber:friendDic["phone_text"] as? String, zone: "86") { (error) -> Void in
                        if ((error == nil)) {
                            self.verifyFriendArray?.append("success")
                            NSLog("验证成功");
                            
                        } else {
                            
                            
                            self.verifyFriendArray!.append("failure")

//                            self.verifyFriendArray!.addObject(NSMutableDictionary())
                            NSLog("错误信息：%@",error);
                        }
                    }
                    
                    while (self.verifyFriendArray?.count != self.friendArray?.count) {
                        NSThread.sleepForTimeInterval(3)
                    }

                })
            }
        }
        
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            

            
            if self.verifyFriendArray?.count == self.friendArray?.count && !(self.verifyFriendArray?.contains("failure"))! {
                
                let parameters = [
                    "friendArrayMap": self.friendArray as! AnyObject,
                    "meInfo": self.meInfo as! AnyObject
                ]
                
                
                
                
                Alamofire.request(.POST, AppDelegate.baseURLString + "/register", parameters: parameters, encoding: .JSON).responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        let success = response.result.value!["success"]!! as! NSNumber
                        if(success.boolValue) {
                            let alertController = UIAlertController(title: "提示", message: "注册成功", preferredStyle: UIAlertControllerStyle.Alert)
                            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                            alertController.addAction(cancelAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            self.performSelector("backLoginController", withObject: self, afterDelay: 3)
                        } else {
                            
                        }

                    }

                }
                    

            }
        }
        
        
        

        
    }
    
    
    func getVerifyCode(sender:UIButton) {
        
        for var index = 0; index < self.friendArray?.count; ++index {
            let indexPath = NSIndexPath(forRow: 0, inSection: index)
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            if (cell != nil) {
                let userPhoneTextField = cell?.contentView.subviews[0] as? UITextField
                let verifyCodeTextField = cell?.contentView.subviews[1] as? UITextField
                let friendDic = self.friendArray![index]
                friendDic.setObject(userPhoneTextField?.text, forKey: "phone_text")
                friendDic.setObject(verifyCodeTextField?.text, forKey: "verify_code_text")
            }
        }
        
        
        let phoneText = self.friendArray![sender.tag]["phone_text"] as! String
        let verifyButtonStatus = self.verifyButtonStatusArray![sender.tag] as! VerifyButtonStatus
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneText, zone: "86", customIdentifier: nil) { (error) -> Void in
            if ((error == nil)) {
                verifyButtonStatus.isCounting = true
                NSLog("获取验证码成功");
            } else {
                NSLog("错误信息：%@",error);
            }
        }
    }
    
    func backLoginController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}