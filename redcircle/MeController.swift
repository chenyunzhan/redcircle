//
//  MeController.swift
//  redcircle
//
//  Created by zhan on 16/4/5.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit


class MeController: UITableViewController {
    
    var tableData: NSMutableArray?
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.title = "我的"
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let cellModel1 = CellModel()
        cellModel1.title = "手机"
        cellModel1.desc = userDic!["mePhone"] as! String
        
        let cellModel2 = CellModel()
        cellModel2.title = "性别"
        cellModel2.desc = userDic!["sex"] as! String
        
        let cellModel3 = CellModel()
        cellModel3.title = "姓名"
        cellModel3.desc = userDic!["name"] as! String
        
        let cellModel4 = CellModel()
        cellModel4.title = "退出登录"
        cellModel4.desc = ""
        
        
        
        self.tableData = NSMutableArray()
        
        
        let sectionArray1 = NSMutableArray()
        sectionArray1.addObject(cellModel1)
        sectionArray1.addObject(cellModel3)
        sectionArray1.addObject(cellModel2)
        
        let sectionArray2 = NSMutableArray()
        sectionArray2.addObject(cellModel4)
        
        self.tableData?.addObject(sectionArray1)
        self.tableData?.addObject(sectionArray2)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userInfoChange",
            name: "USER_INFO_CHANGE", object: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.tableData?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = self.tableData![section]
        return (sectionArray.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellModel = self.tableData![indexPath.section][indexPath.row] as! CellModel
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.desc
        
        return cell

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            let cellModel = self.tableData![indexPath.section][indexPath.row] as! CellModel
            let modifyController = ModifyController()
            modifyController.subTitle = cellModel.title
            modifyController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(modifyController, animated: true)
        } else {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            UIView.transitionFromView(self.view, toView: loginController.view, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (Bool) -> Void in
                ((UIApplication.sharedApplication().delegate) as! AppDelegate).window?.rootViewController = loginNavController
            })
            
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)

        }

    }
    
    func userInfoChange () {
        self.viewDidLoad()
        self.tableView.reloadData()
    }
}
