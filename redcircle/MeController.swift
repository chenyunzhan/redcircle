//
//  MeController.swift
//  redcircle
//
//  Created by zhan on 16/4/5.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class MeController: UITableViewController {
    
    var tableData: NSMutableArray?
    
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
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
        
        let cellModel5 = CellModel()
        cellModel5.title = "头像"
        cellModel5.image = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (userDic!["mePhone"] as! String)
        let cellModel6 = CellModel()
        cellModel6.title = "红圈"
        cellModel6.desc = ""
        
        let cellModel7 = CellModel()
        cellModel7.title = "朋友圈"
        cellModel7.desc = ""
        
        let cellModel8 = CellModel()
        cellModel8.title = "相册"
        cellModel8.desc = ""
        
        
        
        
        
        
        self.tableData = NSMutableArray()
        
        
        let sectionArray1 = NSMutableArray()
        sectionArray1.addObject(cellModel1)
        sectionArray1.addObject(cellModel3)
        sectionArray1.addObject(cellModel2)
        
        let sectionArray2 = NSMutableArray()
        sectionArray2.addObject(cellModel4)
        
        let sectionArray3 = NSMutableArray()
        sectionArray3.addObject(cellModel5)
        
        let sectionArray4 = NSMutableArray()
        sectionArray4.addObject(cellModel6)
        sectionArray4.addObject(cellModel7)
        sectionArray4.addObject(cellModel8)

        self.tableData?.addObject(sectionArray3)
        self.tableData?.addObject(sectionArray4)
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
        let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.desc
        
        
        
        if(indexPath.section == 0) {
            
            
            let imageView = UIImageView(image: nil)
            cell.contentView.addSubview(imageView)
            cell.accessoryType = UITableViewCellAccessoryType.None

            
            imageView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-18)
                make.height.equalTo(60)
                make.width.equalTo(60)
            })
            
            Alamofire.request(.GET, cellModel.image).response { (request, response, data, error) in
                imageView.image = UIImage(data: data!, scale:1)
            }
            
            
            
        }
        
        return cell

    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 80
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 2) {
            let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
            let modifyController = ModifyController()
            modifyController.subTitle = cellModel.title
            modifyController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(modifyController, animated: true)
        } else if (indexPath.section == 3) {
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
