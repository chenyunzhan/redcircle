//
//  AddFriendController.swift
//  redcircle
//
//  Created by cloud on 16/5/22.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire

typealias sendValueClosure=(string:String)->Void

class AddFriendController: UIViewController {

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
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    
    
    override func viewDidLoad() {
        
        self.title = "朋友信息"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(doAddFriendAction))
        
        
        
        
        
        
        
        
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

    
    
    func doAddFriendAction() {
        
        //        let friendController = FriendController(style: UITableViewStyle.Grouped)
        //        friendController.meInfo = NSDictionary(dictionary: ["me_phone":(self.userPhoneTextField?.text)!])
        //        self.navigationController?.pushViewController(friendController, animated: true)
        
        
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (error) -> Void in
            if ((error == nil)) {
                NSLog("验证成功");
                
                let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")

                let parameters = [
                    "mePhone": userDic!["mePhone"] as! String,
                    "friendPhone": self.userPhoneTextField?.text as! AnyObject,
                    ]
                
                
                
                
                Alamofire.request(.POST, AppDelegate.baseURLString + "/addFriend", parameters: parameters, encoding: .JSON).responseJSON { response in
                    
                    if(response.result.isSuccess) {
                        let success = response.result.value!["success"]!! as! NSNumber
                        if(success.boolValue) {
                            
                            //判空
                            if (self.myClosure != nil){
                                //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                                self.myClosure!(string: "好好哦")
                            }
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            
                        }
                        
                    }
                    
                }
                
                
            } else {
                NSLog("错误信息：%@",error);
            }
        }
        
    }
    
    
    func updateTime(timer: NSTimer) {
        remainingSeconds -= 1
    }

}
