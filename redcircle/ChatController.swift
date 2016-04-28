//
//  ChatController.swift
//  redcircle
//
//  Created by CLOUD on 16/4/6.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation


class ChatController: RCConversationViewController {
    
//    override func sendMessage(messageContent: RCMessageContent!, pushContent: String!) {
//        super.sendMessage(messageContent, pushContent: pushContent)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let rightImage = UIImage.fontAwesomeIconWithName(.PaperPlaneO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "举报", style: .Done, target: self, action: #selector(ChatController.reportUserAction))
    }
    
    
    
    func reportUserAction() -> Void {
        let reportController = ReportController()
        reportController.userPhone = self.targetId
        self.navigationController?.pushViewController(reportController, animated: true)
    }
    
}