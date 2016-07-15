//
//  MeCircleController.swift
//  redcircle
//
//  Created by zhan on 16/7/7.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Alamofire
import SwiftyJSON
import DGElasticPullToRefresh


class MeCircleController:  UITableViewController {
    
    var circleLevel: String?
    var startNo: String?
    var mePhone: String?
    var tableData: [JSON] = []
    var loadMoreLabel: UILabel?
    var loadMoreIndicatorView: UIActivityIndicatorView?
    var keyboardTextField: SYKeyboardTextField!
    var toComment: JSON?
    var indexOfArticle: Int?

    
    override func viewDidLoad() {
        
        
        

        
        self.tableView.registerClass(ArticleTableViewCell.classForCoder(), forCellReuseIdentifier: ArticleTableViewCell.cellID())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MeCircleController.addArticleAction))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(n), style: .Done, target: self, action: #selector(MeCircleController.addArticleAction))
        
        
        self.refreshData()
        
        
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.refreshData()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        let loadMoreLabel = UILabel(frame: CGRectMake(0,0,0,30))
        loadMoreLabel.textAlignment = .Center
        loadMoreLabel.text = "上拉加载更多"
        loadMoreLabel.textColor = UIColor.grayColor()
//        loadMoreLabel.backgroundColor = UIColor.lightGrayColor()
        self.loadMoreLabel = loadMoreLabel
        
        
        let loadMoreIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,self.tableView.frame.size.width,30))
        loadMoreIndicatorView.color = UIColor.grayColor()
        self.loadMoreIndicatorView = loadMoreIndicatorView
        
        self.tableView.tableFooterView = loadMoreLabel
        
        
    }
    
    override func loadView() {
        super.loadView()
        keyboardTextField = SYKeyboardTextField(point: CGPointMake(0, 0), width: self.view.width)
        keyboardTextField.delegate = self
        keyboardTextField.leftButtonHidden = false
        keyboardTextField.rightButtonHidden = false
        keyboardTextField.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleTopMargin]
        self.view.addSubview(keyboardTextField)
        keyboardTextField.toFullyBottom()
        keyboardTextField.hidden = true
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let article = self.tableData[indexPath.row]
        
        let  cell = tableView.dequeueReusableCellWithIdentifier(ArticleTableViewCell.cellID(), forIndexPath: indexPath) as! ArticleTableViewCell
        cell.controller = self
        cell.cellForModel(article)
        cell.tag = indexPath.row

        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let article = self.tableData[indexPath.row]
        
        return ArticleTableViewCell.heightForModel(article)
    }
    
    
    func addArticleAction() {
        let addArticle = AddArticleController()
        addArticle.initWithClosure(someFunctionThatTakesAClosure)

        self.navigationController?.pushViewController(addArticle, animated: true)
    }
    
    
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }
    
    
    func refreshData() -> Void {
        
        if(circleLevel == "0") {
            self.title = "相册"
        } else if (circleLevel == "1") {
            self.title = "朋友圈"
        }
        
        startNo = "0"
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        mePhone = userDic!["mePhone"] as? String
        
        
        let parameters = [
            "mePhone": mePhone!,
            "circleLevel": circleLevel!,
            "startNo": startNo!
        ]
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getArticles", parameters: parameters).responseJSON { response in
            let tableData = JSON(response.result.value!).arrayValue
            self.tableData = tableData
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()

        }

    }
    
    
    func loadMoreData() -> Void {
        
        self.tableView.tableFooterView = self.loadMoreIndicatorView
        self.loadMoreIndicatorView?.startAnimating()
        
        startNo = String(Int(startNo!)! + 10)
        
        let parameters = [
            "mePhone": mePhone!,
            "circleLevel": circleLevel!,
            "startNo": startNo!
        ]
        Alamofire.request(.GET, AppDelegate.baseURLString + "/getArticles", parameters: parameters).responseJSON { response in
            
            self.tableView.tableFooterView = self.loadMoreLabel
            self.loadMoreIndicatorView?.stopAnimating()

            
            let tableData = JSON(response.result.value!).arrayValue
            self.tableData = self.tableData + tableData
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
            
        }
    }
    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (Float(scrollView.contentOffset.y) >= fmaxf(0, Float(scrollView.contentSize.height - scrollView.frame.size.height)) + 30) //x是触发操作的阀值
        {
            //触发上拉刷新
            self.loadMoreData()
        }
    }
    
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        keyboardTextField.hide()
    }
    
    


}


//MARK: SYKeyboardTextFieldDelegate
extension MeCircleController : SYKeyboardTextFieldDelegate {
    func keyboardTextFieldPressReturnButton(keyboardTextField: SYKeyboardTextField) {
//        UIAlertView(title: "", message: "Action", delegate: nil, cancelButtonTitle: "OK").show()
        keyboardTextField.hide()

        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
//        let parameters = [
//            "mePhone": self.userPhoneTextField?.text as! AnyObject,
//            ]
        
        let parameters = [
            "articleId": self.toComment!["article_id"].string,
            "content": keyboardTextField.text,
            "commentBy": userDic!["mePhone"] as! String,
            "commentTo": self.toComment!["commenter_by"].string
            ]
//        Alamofire.request(.POST, AppDelegate.baseURLString + "/login", parameters: parameters, encoding: .JSON).responseJSON { response in

        
        Alamofire.request(.POST, AppDelegate.baseURLString + "/addComment", parameters: parameters).responseJSON { response in
            
            if(response.result.isSuccess) {
                
//                var article = self.tableData[self.indexOfArticle!]
//                article["comments"].arrayObject = JSON(response.result.value!).arrayObject
                
                
                self.tableData[self.indexOfArticle!]["comments"].arrayObject = JSON(response.result.value!).arrayObject
                self.tableView.reloadData()
            }
            
        }
    }
    
    func keyboardTextFieldDidHide(keyboardTextField :SYKeyboardTextField) {
        keyboardTextField.hidden = true
    }
    
}