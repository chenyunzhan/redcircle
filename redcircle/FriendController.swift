//
//  FriendController.swift
//  redcircle
//
//  Created by zhan on 16/3/30.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton

class FriendController: UITableViewController {
    
    var friendArray: NSMutableArray?
    
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
        let cell = UITableViewCell()
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = String(format: "请输入您朋友%d的手机号", indexPath.section+1)

        cell.contentView.addSubview(userPhoneTextField)
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        cell.contentView.addSubview(verifyCodeTextField)
        
        let verifyCodeButton = SwiftyButton()
        verifyCodeButton.tag = indexPath.section
        verifyCodeButton.buttonColor = UIColor.redColor()
        verifyCodeButton.highlightedColor = UIColor.orangeColor()
        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
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
            let userPhoneTextField = cell?.contentView.subviews[0] as? UITextField
            let verifyCodeTextField = cell?.contentView.subviews[1] as? UITextField
            let friendDic = self.friendArray![index]
            friendDic.setObject(userPhoneTextField?.text, forKey: "phone_text")
            friendDic.setObject(verifyCodeTextField?.text, forKey: "verify_code_text")
        }
        
        
        
        
        self.friendArray?.addObject(NSMutableDictionary())
        self.tableView.reloadData()
    }
    
    
    func doResigterAction() {
        
        for friendDic in self.friendArray! {
            SMSSDK.commitVerificationCode(friendDic["verify_code_text"] as? String, phoneNumber:friendDic["phone_text"] as? String, zone: "86") { (error) -> Void in
                if ((error == nil)) {
                    NSLog("验证成功");
                    
                } else {
                    NSLog("错误信息：%@",error);
                    return
                }
            }
        }
        
        
    }
    
    
    func getVerifyCode(sender:UIButton) {
        let phoneText = self.friendArray![sender.tag]["phone_text"] as! String
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneText, zone: "86", customIdentifier: nil) { (error) -> Void in
            if ((error == nil)) {
                NSLog("获取验证码成功");
            } else {
                NSLog("错误信息：%@",error);
            }
        }
    }
}