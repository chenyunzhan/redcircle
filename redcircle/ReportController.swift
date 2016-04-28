//
//  ReportController.swift
//  redcircle
//
//  Created by CLOUD on 16/4/27.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire



class ReportController: UITableViewController {
    
    
    var tableData: NSMutableArray?
    var selectedReportType: NSDictionary?
    var userPhone: NSString?
    
    
    override func viewDidLoad() {
        
        self.title = "举报用户";
        
        let tableData = NSMutableArray()
        
        let reportType1 = ["type":"1","name":"色情低俗"]
        
        let reportType2 = ["type":"2","name":"广告骚扰"]
        
        let reportType3 = ["type":"3","name":"政治敏感"]
        
        let reportType4 = ["type":"4","name":"谣言"]
        
        let reportType5 = ["type":"5","name":"欺诈骗钱"]
        
        let reportType6 = ["type":"6","name":"违法（暴力恐怕、违禁品等）"]
        
        let reportType7 = ["type":"7","name":"售假举报"]
        
        
        tableData.addObject(reportType1)
        tableData.addObject(reportType2)
        tableData.addObject(reportType3)
        tableData.addObject(reportType4)
        tableData.addObject(reportType5)
        tableData.addObject(reportType6)
        tableData.addObject(reportType7)
        
        
        self.tableData = tableData
        
        
        let rightImage = UIImage.fontAwesomeIconWithName(.PaperPlaneO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Done, target: self, action: #selector(ReportController.doSubmitReport))

        
    }
 
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reportType = self.tableData![indexPath.row] as! NSDictionary
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.textLabel?.text = reportType["name"] as? String
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView .cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.selectedReportType = self.tableData![indexPath.row] as? NSDictionary
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView .cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
    }
    
    
    func doSubmitReport() -> Void {
        let report = NSMutableDictionary(dictionary: self.selectedReportType!)
        report.setObject(self.userPhone!, forKey: "userPhone")
        
        let parameters = [
            "report": report,
            ]
        Alamofire.request(.POST, AppDelegate.baseURLString + "/reportUser", parameters: parameters, encoding: .JSON).responseJSON { response in
            if response.result.isSuccess {
                
                if (response.result.isSuccess) {
                    let alertController = UIAlertController(title: "提示", message: "感谢您的反馈，我们会及时进行处理", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "确定", style: .Default) { (action) in
                        // pop here
                        if let navController = self.navigationController {
                            navController.popViewControllerAnimated(true)
                        }
                    }
//                    let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

            }
        }
    }
    
}
