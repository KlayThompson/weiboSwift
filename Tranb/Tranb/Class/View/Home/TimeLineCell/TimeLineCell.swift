//
//  TimeLineCell.swift
//  Tranb
//
//  Created by Kim on 2017/6/12.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell {

    
    /// 用户头像
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员等级icon
    @IBOutlet weak var memberIconView: UIImageView!
    
    /// 发布时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 头像右下角标识icon
    @IBOutlet weak var avatarIdentifyImageView: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var timeLineTextLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
