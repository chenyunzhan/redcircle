//
//  LoginController.swift
//  redcircle
//
//  Created by zhan on 16/3/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyButton
import Alamofire

class LoginController: UIViewController {
    
    var userPhoneTextField: UITextField?
    var logoImageView: UIImageView?
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true
        
        let registerButton = UIButton()
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(registerButton)
        self.view.backgroundColor = UIColor.whiteColor()
        
        let forgetPasswordButton = UIButton()
        forgetPasswordButton.setTitle("忘记密码", forState: UIControlState.Normal)
        forgetPasswordButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(forgetPasswordButton)
        
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "pix")
        self.logoImageView = logoImageView
        self.view.addSubview(logoImageView)
        
        
        
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = "请输入您的手机号"
        self.view.addSubview(userPhoneTextField)
        self.userPhoneTextField = userPhoneTextField
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        self.view.addSubview(verifyCodeTextField)
        
        let verifyCodeButton = SwiftyButton()
        verifyCodeButton.buttonColor = UIColor.redColor()
        verifyCodeButton.highlightedColor = UIColor.orangeColor()
        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        verifyCodeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        verifyCodeButton.addTarget(self, action: "getVerifyCode:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(verifyCodeButton)
        
        
        let loginButton = SwiftyButton()
        loginButton.buttonColor = UIColor.redColor()
        loginButton.highlightedColor = UIColor.orangeColor()
        loginButton.shadowHeight = 0
        loginButton.cornerRadius = 5
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "doLoginAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(loginButton)
        
        
        let userPhoneLineView = UIView()
        userPhoneLineView.backgroundColor = UIColor.redColor()
        self.view .addSubview(userPhoneLineView)
        
        let verifyCodeLineView = UIView()
        verifyCodeLineView.backgroundColor = UIColor.redColor()
        self.view.addSubview(verifyCodeLineView)
        
        userPhoneTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(logoImageView.snp_bottom).offset(20)
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
        
        registerButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(loginButton.snp_bottom).offset(8)
            make.left.equalTo(loginButton)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        forgetPasswordButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(loginButton.snp_bottom).offset(8)
            make.right.equalTo(loginButton)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        
        logoImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        loginButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(userPhoneTextField)
            make.left.equalTo(userPhoneTextField)
            make.top.equalTo(verifyCodeTextField.snp_bottom).offset(30)
            make.height.equalTo(40)
        }
        
        
        registerButton.addTarget(self, action: "gotoRegisterController", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            self.registerForKeyboardNotifications()
        }
        
    }
    
    
    func gotoRegisterController() {
        let registerController = RegisterController()
        self.navigationController?.pushViewController(registerController, animated: true)
    }
    
    func getVerifyCode(sender:UIButton) {
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: self.userPhoneTextField!.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            if ((error == nil)) {
                NSLog("获取验证码成功");
            } else {
                NSLog("错误信息：%@",error);
            }
        }
    }
    
    
    func doLoginAction() {
        SMSSDK.commitVerificationCode(self.userPhoneTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (error) -> Void in
            if ((error == nil) || true) {
                NSLog("验证成功");
                let parameters = [
                    "mePhone": self.userPhoneTextField?.text as! AnyObject,
                ]
                Alamofire.request(.POST, AppDelegate.baseURLString + "/login", parameters: parameters, encoding: .JSON).responseJSON { response in
                    if response.result.isSuccess {
                        let homeController = HomeController()
                        ((UIApplication.sharedApplication().delegate) as! AppDelegate).window?.rootViewController = homeController
                        let userDic = response.result.value as? NSDictionary
                        NSUserDefaults.standardUserDefaults().setObject(userDic, forKey: "USER_INFO")

                    }
                }
            } else {
                NSLog("错误信息：%@",error);
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification : NSNotification) {
        self.logoImageView?.snp_updateConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(150)
            make.height.equalTo(150)

        })
    }
    
    func keyboardWillBeHidden(notification : NSNotification) {
        self.logoImageView?.snp_updateConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(150)
            make.height.equalTo(150)
            
        })
    }
    
}