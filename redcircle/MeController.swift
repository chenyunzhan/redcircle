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
        
        
        self.tableData = NSMutableArray()
        self.tableData?.addObject(cellModel1)
        self.tableData?.addObject(cellModel3)
        self.tableData?.addObject(cellModel2)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userInfoChange",
            name: "USER_INFO_CHANGE", object: nil)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellModel = self.tableData![indexPath.row] as! CellModel
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.desc
        
        return cell

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellModel = self.tableData![indexPath.row] as! CellModel
        let modifyController = ModifyController()
        modifyController.subTitle = cellModel.title
        modifyController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(modifyController, animated: true)
    }
    
    func userInfoChange () {
        self.viewDidLoad()
        self.tableView.reloadData()
    }
}
