//
//  RegisterController.swift
//  redcircle
//
//  Created by zhan on 16/3/30.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton

class RegisterController: UIViewController {
    
    var userPhoneTextField: UITextField?
    var verifyCodeTextField: UITextField?
    
    var sendButton: SwiftyButton!
    
    var countdownTimer: NSTimer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("\(newValue)", forState: .Normal)
            
            if newValue <= 0 {
                sendButton.setTitle("重新获取", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                
                remainingSeconds = 100
                
                sendButton.buttonColor  = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.buttonColor  = UIColor.redColor()
            }
            
            sendButton.enabled = !newValue
        }
    }
    
    
    override func viewDidLoad() {
        
        self.title = "个人信息"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.Done, target: self, action: "gotoFriendController")
        
        
        

        
        
        
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = "请输入您的手机号"
        self.view.addSubview(userPhoneTextField)
        self.userPhoneTextField = userPhoneTextField
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        self.view.addSubview(verifyCodeTextField)
        self.verifyCodeTextField = verifyCodeTextField
        
        let verifyCodeButton = SwiftyButton()
        verifyCodeButton.buttonColor = UIColor.redColor()
        verifyCodeButton.highlightedColor = UIColor.orangeColor()
        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        verifyCodeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        verifyCodeButton.addTarget(self, action: "getVerifyCode:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(verifyCodeButton)
        self.sendButton = verifyCodeButton
        
        
        let agreementButton = UIButton();
        agreementButton.setTitle("使用条款和隐私政策", forState: .Normal)
        agreementButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        agreementButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        agreementButton.addTarget(self, action: #selector(RegisterController.readAgreementAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(agreementButton)
        
        let agreementButton1 = UIButton();
        agreementButton1.setTitle("注册代表同意", forState: .Normal)
        agreementButton1.titleLabel!.font = UIFont.systemFontOfSize(13)
        agreementButton1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(agreementButton1)
        
        
        let userPhoneLineView = UIView()
        userPhoneLineView.backgroundColor = UIColor.redColor()
        self.view .addSubview(userPhoneLineView)
        
        let verifyCodeLineView = UIView()
        verifyCodeLineView.backgroundColor = UIColor.redColor()
        self.view.addSubview(verifyCodeLineView)
        
        userPhoneTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(114)
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp_bottom).offset(8)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp_bottom).offset(8)
            make.right.equalTo(self.view).offset(-20)
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
        
        
        agreementButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(45)
            make.top.equalTo(verifyCodeButton.snp_bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        agreementButton1.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-53)
            make.top.equalTo(verifyCodeButton.snp_bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
    
    
    func getVerifyCode(sender:UIButton) {
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: self.userPhoneTextField!.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            if ((error == nil)) {
                self.isCounting = true
                NSLog("获取验证码成功");
            } else {
                let alertController = UIAlertController(title: "提示", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                NSLog("错误信息：%@",error);
            }
        }
    }
    
    func readAgreementAction() {
        let agreementController = WebViewController()
        let agreementControllerNav = UINavigationController(rootViewController: agreementController)
        self.presentViewController(agreementControllerNav, animated: true, completion: nil)
    }
    
    
    func gotoFriendController() {
        
//        let friendController = FriendController(style: UITableViewStyle.Grouped)
//        friendController.meInfo = NSDictionary(dictionary: ["me_phone":(self.userPhoneTextField?.text)!])
//        self.navigationController?.pushViewController(friendController, animated: true)
        
        
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (error) -> Void in
            if ((error == nil)) {
                NSLog("验证成功");
                
                let friendController = FriendController(style: UITableViewStyle.Grouped)
                friendController.meInfo = NSDictionary(dictionary: ["me_phone":(self.userPhoneTextField?.text)!])
                self.navigationController?.pushViewController(friendController, animated: true)
            } else {
                NSLog("错误信息：%@",error);
            }
        }
        
    }
    
    
    func updateTime(timer: NSTimer) {
        remainingSeconds -= 1
    }
}
