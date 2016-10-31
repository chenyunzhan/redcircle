//
//  ChatController.swift
//  redcircle
//
//  Created by CLOUD on 16/4/6.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation
import SKPhotoBrowser

class ChatController: RCConversationViewController, SKPhotoBrowserDelegate {
    
//    override func sendMessage(messageContent: RCMessageContent!, pushContent: String!) {
//        super.sendMessage(messageContent, pushContent: pushContent)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        
//        let rightImage = UIImage.fontAwesomeIconWithName(.PaperPlaneO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
        let mannersDic = NSUserDefaults.standardUserDefaults().objectForKey("MANNERS_INFO")

        
        if mannersDic == nil {
            
            let alertController = UIAlertController(title: "请保持社交礼仪", message: "请大家文明聊天，保持自己的良好形象，广告、欺骗、粗鲁的行为都会被惩罚。", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: "MANNERS_INFO")
        }
        
        
        RCIMClient.sharedRCIMClient().getBlacklistStatus(self.targetId, success: { (bizStatus) in
            if (bizStatus == 0) {
                let item1 = UIBarButtonItem(title: "取消屏蔽", style: .Done, target: self, action: #selector(ChatController.blackUserAction))
                let item2 = UIBarButtonItem(title: "举报", style: .Done, target: self, action: #selector(ChatController.reportUserAction))
                
                self.navigationItem.rightBarButtonItems = [item2,item1]
            } else {
                let item1 = UIBarButtonItem(title: "屏蔽", style: .Done, target: self, action: #selector(ChatController.blackUserAction))
                let item2 = UIBarButtonItem(title: "举报", style: .Done, target: self, action: #selector(ChatController.reportUserAction))
                
                self.navigationItem.rightBarButtonItems = [item2,item1]
            }
        }) { (status) in
                
        }

        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func didTapCellPortrait(userId: String!) {
        super.didTapCellPortrait(userId)
        // add SKPhoto Array from UIImage
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId + "&type=original")
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        browser.delegate = self
        presentViewController(browser, animated: true, completion: {})
    }
    
    
    
    func reportUserAction() -> Void {
        let reportController = ReportController()
        reportController.userPhone = self.targetId
        self.navigationController?.pushViewController(reportController, animated: true)
    }
    
    
    
    func blackUserAction(blackItem: UIBarButtonItem) -> Void {
        
        
        if (blackItem.title == "屏蔽") {
            RCIMClient.sharedRCIMClient().addToBlacklist(self.targetId, success: {
                dispatch_async(dispatch_get_main_queue(), { 
                    blackItem.title = "取消屏蔽"
                })
            }) { (status) in
                let alertController = UIAlertController(title: "提示", message: "屏蔽失败", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        } else {
            RCIMClient.sharedRCIMClient().removeFromBlacklist(self.targetId, success: {
                dispatch_async(dispatch_get_main_queue(), {
                    blackItem.title = "屏蔽"
                })
            }, error: { (status) in
                let alertController = UIAlertController(title: "提示", message: "取消屏蔽失败", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)

            })
            

        }
        
        
        
        
        
    }
    
}