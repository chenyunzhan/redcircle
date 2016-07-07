//
//  BookTableViewCell.swift
//  redcircle
//
//  Created by zhan on 16/7/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyJSON


class ArticleTableViewCell: UITableViewCell {
    
    
    var  nameLabel : UILabel!
    var  contentLabel : UILabel!
    var  commentButton : UIButton!
    var  photoImageView : UIImageView!
    
    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: BookTableViewCell.cellID())
        
        // 头像img
        nameLabel = UILabel()
        contentLabel = UILabel()
        commentButton = UIButton()
        photoImageView = UIImageView()
        
        
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(photoImageView)
        
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
        
        
    }
    
    class func heightForModel(model: JSON?) -> CGFloat {
        return 100
    }
    
    
    // 根据model 填充Cell
    func cellForModel(model: JSON?){
        if let friend = model {
            
            if (friend["name"].string?.characters.count > 0) {
                nameLabel.text = friend["name"].string
            } else {
                nameLabel.text = friend["created_by"].string
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
    
}
