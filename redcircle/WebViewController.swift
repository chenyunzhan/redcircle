//
//  WebViewController.swift
//  redcircle
//
//  Created by CLOUD on 16/5/10.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit


class WebViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        self.title = "用户协议";
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .Done, target: self, action: #selector(WebViewController.cancelAction))
        
        
        let webView = UIWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(URL: (NSURL(string: baseURLString + "/agreement.html"))!))
        
        
        self.view.addSubview(webView)
        
    }
    
    
    func cancelAction() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
