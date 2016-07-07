//
//  BookTableViewCell.swift
//  redcircle
//
//  Created by zhan on 16/7/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyJSON


class BookTableViewCell: UITableViewCell {
    
    
    var  nameLabel : UILabel!
    var  descLabel : UILabel!
    var  intimacyButton : UIButton!
    
    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: BookTableViewCell.cellID())
        
        // 头像img
        nameLabel = UILabel()
        descLabel = UILabel()
        intimacyButton = UIButton()
        
        
        descLabel.font = UIFont.systemFontOfSize(12)

        
        let image = UIImage.fontAwesomeIconWithName(.Heartbeat, textColor: UIColor.lightGrayColor(), size: CGSizeMake(18, 18))
        intimacyButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        intimacyButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        intimacyButton.setImage(image, forState: .Normal)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descLabel)
        self.contentView.addSubview(intimacyButton)
        
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(descLabel.snp_left).offset(-8)
            make.left.equalTo(self.contentView).offset(20)
        }
        
        intimacyButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-8)
        }
        
        descLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(nameLabel.snp_right).offset(8)
        }
        
    }
    
    
    // 根据model 填充Cell
    func cellForModel(model: JSON?){
        if let friend = model {
            nameLabel.text = friend["name"].string
            intimacyButton.setTitle(friend["intimacy"].string, forState: .Normal)
            
            let name = friend["name"].string
            
            if name != "" {
                nameLabel.text = friend["name"].string
            } else {
                nameLabel.text = friend["mePhone"].string
            }
            
            if friend["recommendLanguage"].string != ""{
                descLabel.text = "(" + friend["recommendLanguage"].string! + ")"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 类方法 重用标识符
    class func cellID () -> String {
        return "BookTableViewCell"
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
