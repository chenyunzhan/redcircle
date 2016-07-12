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



class ArticleTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var  nameLabel : UILabel!
    var  contentLabel : UILabel!
    var  commentButton : UIButton!
    var  photoImageView : UIImageView!
    var  imageCollectionView : UICollectionView!
    var  createLabel : UILabel!
    
    
    var  imageData : [String]?
    var  widthConstraint: Constraint?

    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: BookTableViewCell.cellID())
    

        
        // 头像img
        nameLabel = UILabel()
        contentLabel = UILabel()
        commentButton = UIButton()
        createLabel = UILabel()
        photoImageView = UIImageView()
        imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout.init());
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
        imageCollectionView.backgroundColor = UIColor.clearColor()
        commentButton.setImage(UIImage(named: "bg_comment_pressed"), forState: .Normal)
        
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(imageCollectionView)
        self.contentView.addSubview(createLabel)
        self.contentView.addSubview(commentButton)
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

        }
        
        imageCollectionView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(8)
            make.left.equalTo(photoImageView.snp_right).offset(8)
            widthConstraint = make.width.equalTo(0).constraint
            make.height.equalTo(80)
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
            return CGFloat(row * 80) + 120
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
            
            
            contentLabel.text = friend["content"].string
            
            createLabel.text = friend["created_at"].string
            
            let imageData = friend["images"].string?.componentsSeparatedByString("#")
            
            self.imageData = imageData
            
            
            widthConstraint?.updateOffset((self.imageData?.count)!*80-80)
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
        
        
        
        let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + self.imageData![indexPath.row]
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
    
}
