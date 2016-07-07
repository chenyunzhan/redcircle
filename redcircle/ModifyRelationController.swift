//
//  ModifyController.swift
//  redcircle
//
//  Created by zhan on 16/4/7.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class ModifyRelationController: UIViewController {
    
    
    var mePhone: String?
    var friendPhone: String?
    var textField: UITextField?
    
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    
    override func viewDidLoad() {
        
        self.title = "朋友推荐语"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ModifyRelationController.doModifyAction));
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textField = UITextField()
        textField.placeholder = "请用一句话来描述朋友和你的关系或推荐语"
        self.textField = textField
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
    
        
        let parameters = [
            "mePhone" : mePhone!,
            "friendPhone"   : friendPhone!,
            "recommendLanguage" : (self.textField?.text)!
        ]
        
        
        Alamofire.request(.POST, AppDelegate.baseURLString + "/modifyDetail", parameters: parameters, encoding: .JSON).responseJSON { response in
            if response.result.isSuccess {
                //判空
                if (self.myClosure != nil){
                    //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                    self.myClosure!(string: "好好哦")
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
}