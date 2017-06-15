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
            timeLineTextLabel.text = viewModel?.timeLineModel.text
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
            pictureView.heightCons.constant = viewModel?.pictureSize.height ?? 0
            //微博配图传值
//            //写测试代码,测试4张微博配图
//            if (viewModel?.timeLineModel.pic_urls?.count)! > 4 {
//                
//                var array = viewModel?.timeLineModel.pic_urls
//                
//                array?.removeSubrange(((array?.startIndex)! + 4)..<(array?.endIndex)!)
//                pictureView.urls = array
//                
//            } else {
//                pictureView.urls = viewModel?.timeLineModel.pic_urls
//            }
            pictureView.urls = viewModel?.picUrlsLarge
            //转发微博文字
            retweetLabel?.text = viewModel?.reTweetText
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
