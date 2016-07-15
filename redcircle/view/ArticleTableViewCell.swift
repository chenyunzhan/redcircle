//
//  BookTableViewCell.swift
//  redcircle
//
//  Created by zhan on 16/7/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SnapKit
import ActiveLabel



class ArticleTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    var controller: MeCircleController!

    
    var  nameLabel : UILabel!
    var  contentLabel : ActiveLabel!
    var  commentButton : UIButton!
    var  photoImageView : UIImageView!
    var  imageCollectionView : UICollectionView!
    var  commentTableView: UITableView!
    var  createLabel : UILabel!
    
    
    var  imageData : [String]?
    var  commentData : [JSON]?
    
    var  widthConstraint: Constraint?
    var  heightConstraint: Constraint?
    var  heightConstraintOfComment: Constraint?


    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: BookTableViewCell.cellID())
    

        
        // 头像img
        nameLabel = UILabel()
        contentLabel = ActiveLabel()
    
        
        commentButton = UIButton()
        createLabel = UILabel()
        photoImageView = UIImageView()
        imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout.init());
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
        imageCollectionView.backgroundColor = UIColor.clearColor()
        commentButton.setImage(UIImage(named: "bg_comment_pressed"), forState: .Normal)
        commentButton.addTarget(self, action: #selector(ArticleTableViewCell.addCommentToArticle), forControlEvents: .TouchUpInside)
        commentTableView = UITableView()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.backgroundView = UIImageView.init(image: UIImage(named: "comment_table_back_image")?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 20, 5, 5)))
        commentTableView.backgroundColor = UIColor.clearColor()
        commentTableView.tableHeaderView = UIView(frame: CGRectMake(0,0,0,10))
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(imageCollectionView)
        self.contentView.addSubview(createLabel)
        self.contentView.addSubview(commentButton)
        self.contentView.addSubview(commentTableView)
//        self.contentView.addSubview(tableView)

        
        photoImageView.snp_makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(20)
            make.left.equalTo(photoImageView.snp_right).offset(8)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(8)
            make.left.equalTo(photoImageView.snp_right).offset(8)
            make.right.equalTo(-8)

        }
        
        imageCollectionView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(8)
            make.left.equalTo(photoImageView.snp_right).offset(8)
            widthConstraint = make.width.equalTo(0).constraint
            heightConstraint = make.height.equalTo(80).constraint
        }
        
        commentTableView.snp_makeConstraints { (make) in
            make.top.equalTo(createLabel.snp_bottom).offset(8)
            make.left.equalTo(photoImageView.snp_right).offset(8)
            make.right.equalTo(-8)
            heightConstraintOfComment = make.height.equalTo(80).constraint
        }
        
        createLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageCollectionView.snp_bottom).offset(8)
            make.left.equalTo(photoImageView.snp_right).offset(8)
        }
        
        commentButton.snp_makeConstraints { (make) in
            make.top.equalTo(imageCollectionView.snp_bottom).offset(8)
            make.trailing.equalTo(-8)
        }
        
//        tableView.snp_makeConstraints { (make) in
//            make.top.equalTo(contentLabel.snp_bottom).offset(10)
//            make.left.equalTo(photoImageView.snp_right).offset(8)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            
//        }
        
        
    }
    
    class func heightForModel(model: JSON?) -> CGFloat {
        
        
        

        
        
        if let friend = model {
            let imageData = friend["images"].string?.componentsSeparatedByString("#")
            let count = (imageData?.count)!-1
            var row = 0
            
            if (0 < count && count <= 3) {
                row = 1
            } else if(3 < count && count <= 6) {
                row = 2
            } else if(6 < count) {
                row = 3
            }
            
            
            let commentData = friend["comments"].array

            
            let myRect:CGRect = UIScreen.mainScreen().bounds;

            return CGFloat(row * 80) + 120 + getLabHeigh(friend["content"].string!, font: UIFont.systemFontOfSize(17), width: myRect.width-72) + CGFloat(((commentData?.count)! * 20))
        }
        return 44
    }
    
    
    // 根据model 填充Cell
    func cellForModel(model: JSON?){
        if let friend = model {
        
            
            if (friend["name"].string?.characters.count > 0) {
                nameLabel.text = friend["name"].string
            } else {
                nameLabel.text = friend["created_by"].string
            }
            let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + friend["created_by"].string! + "&type=thumbnail"
            Alamofire.request(.GET, imageUrl).response { (request, response, data, error) in
                self.photoImageView.image = UIImage(data: data!, scale:1)
            }
            
            
            contentLabel.customize { label in
                
                
                label.text = friend["content"].string?.stringByReplacingOccurrencesOfString("http", withString: " http")

                
                label.numberOfLines = 0
                label.lineSpacing = 4
                
                label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
                label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
                label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
                label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
                label.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
                
                label.handleMentionTap { self.alert("Mention", message: $0) }
                label.handleHashtagTap { self.alert("Hashtag", message: $0) }
                label.handleURLTap { self.alert("URL", message: $0.absoluteString) }
            }
            
            createLabel.text = friend["created_at"].string
            
            
            commentButton.titleLabel?.text = friend["id"].string
            
            let imageData = friend["images"].string?.componentsSeparatedByString("#")
            
            self.imageData = imageData
            self.imageCollectionView .reloadData()
            
            let commentData = friend["comments"].array
            self.commentData = commentData
            self.commentTableView.reloadData()
            
            widthConstraint?.updateOffset((self.imageData?.count)!*80-80)
            
            
            if self.imageData?.count == 1 {
                heightConstraint?.updateOffset(0)
            } else {
                heightConstraint?.updateOffset(80)
            }

            if self.commentData?.count == 0 {
                heightConstraintOfComment?.updateOffset(0)
            } else {
                heightConstraintOfComment?.updateOffset((self.commentData?.count)! * 20 + 10)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 类方法 重用标识符
    class func cellID () -> String {
        return "ArticleTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        
        // Configure the view for the selected state
    }
    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 2
//    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(80, 80)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imageData?.count)!-1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let identify:String = "CommandCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as UICollectionViewCell
    
        
        let imageView = UIImageView()
        
        cell.contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(cell.contentView).inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
        
        
        let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + self.imageData![indexPath.row] + "&type=thumbnail"
        Alamofire.request(.GET, imageUrl).response { (request, response, data, error) in
            imageView.image = UIImage(data: data!, scale:1)
        }
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.commentData == nil) {
            return 0
        }
        return (self.commentData?.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let comment = self.commentData![indexPath.row]
        
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        
        var commenterBy = comment["commenter_by_name"].string
        if commenterBy == "" {
            commenterBy = comment["commenter_by"].string
        }
        
        var commenterTo = comment["commenter_to_name"].string
        if commenterTo == "" {
            commenterTo = comment["commenter_to"].string
        }
        
        cell.textLabel?.text = commenterBy! + ": " + comment["content"].string!
        
        if commenterTo != nil {
            cell.textLabel?.text = commenterBy! + "回复" + commenterTo! + ": " + comment["content"].string!
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        controller.keyboardTextField.show()
        controller.keyboardTextField.hidden = false
        controller.toComment = self.commentData![indexPath.row]
    }
    
    class func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr
        let size = CGSizeMake(width, 900)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName)
        let strSize = statusLabelText.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    
    func alert(title: String, message: String) {
        let url = NSURL(string: message)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    func addCommentToArticle(sender: UIButton) -> Void {
        controller.keyboardTextField.show()
        controller.keyboardTextField.hidden = false
        controller.toComment = ["commenter_by":"","article_id":(sender.titleLabel?.text)!]
        controller.indexOfArticle = self.tag
    }
    
}
