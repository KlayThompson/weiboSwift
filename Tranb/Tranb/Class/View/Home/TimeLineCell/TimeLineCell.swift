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
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: TimeLineToolBarView!
    
    /// 微博配图
    @IBOutlet weak var pictureView: TimeLinePictureView!
    
    /// 转发微博文字，因为原创cell不存在，故此处用？可选的
    @IBOutlet weak var retweetLabel: UILabel?
    
    
    var viewModel: SingleTimeLineViewModel? {
        didSet {
            //微博内容
            timeLineTextLabel.attributedText = viewModel?.timeLineAttriText
            //转发微博文字
            retweetLabel?.attributedText = viewModel?.reTweetAttriText
            //用户名
            nameLabel.text = viewModel?.timeLineModel.user?.screen_name
            //会员标识
            memberIconView.image = viewModel?.memberImage
            //认证图标
            avatarIdentifyImageView.image = viewModel?.avatarIdentifyImage
            //用户头像
            avatarImageView.setImage(urlString: viewModel?.timeLineModel.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            //微博配图
            pictureView.viewModel = viewModel
            //微博来源
            sourceLabel.text = viewModel?.timeLineModel.source
            
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //离屏渲染
        self.layer.drawsAsynchronously = true
        //栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
