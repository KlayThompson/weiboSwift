//
//  SingleTimeLineViewModel.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/12.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/// 单个微博视图模型
class SingleTimeLineViewModel: CustomStringConvertible {
    
    var timeLineModel: TimeLineModel
    
    /// 会员图标
    var memberImage: UIImage?
    
    //头像右下角标识icon  认证类型：-1 没有认证，0认证用户，2，3，5企业认证， 220达人
    var avatarIdentifyImage: UIImage?
    
    /// 转发
    var retweetStr: String?
    
    /// 评论
    var commentStr: String?
    
    /// 点赞
    var likeStr: String?
    
    /// 微博配图尺寸
    var pictureSize = CGSize()
    
    /// 若果转发微博有配图就返回转发微博配图，没有就返回原创
    var picUrls: [TimeLinePictureUnit] {
        return timeLineModel.retweeted_status?.pic_urls ?? (timeLineModel.pic_urls ?? [])
    }
    
    /// 被转发微博文字
    var reTweetText: String?
    
    
    /// 返回单个微博的视图模型
    ///
    /// - Parameter model: TimeLineModel
    init(model: TimeLineModel) {
        self.timeLineModel = model
        
        guard let user = model.user else {
            return
        }
        
        //common_icon_membership_level1  0-6  会员图标
        if user.mbrank > 0 && user.mbrank < 7 {
            let imageString = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberImage = UIImage(named: imageString)
        }
        
        //认证图标
        switch user.verified_type {
        case 0:
            avatarIdentifyImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            avatarIdentifyImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            avatarIdentifyImage = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //底部toolbar
        retweetStr = countString(count: model.reposts_count, defaultString: "转发")
        commentStr = countString(count: model.comments_count, defaultString: "评论")
        likeStr = countString(count: model.attitudes_count, defaultString: "赞")
        
        //微博配图尺寸计算
        pictureSize = calulatorPictureSize(imageCount: picUrls.count)
        
        //被转发微博文字
        reTweetText = "@" + (model.retweeted_status?.user?.screen_name ?? "") + "：" + (model.retweeted_status?.text ?? "")
        
    }
    
    /// 计算微博配图视图整体的尺寸
    ///
    /// - Parameter imageCount: 微博配图的数量
    /// - Returns: return 微博配图视图整体的尺寸
    func calulatorPictureSize(imageCount: Int?) -> CGSize {
        
        //如果不存在count或者count为0则返回空
        if imageCount == 0 || imageCount == nil {
            return CGSize()
        }
    
        //计算高度
        //行数
        let row = (imageCount! - 1)/3 + 1
        
        //根据行数计算高度
        let height = OutMargin + CGFloat(row)*PicWidth + CGFloat(row - 1)*InMargin
        
        return CGSize(width: ViewWidth, height: height)
    }
    
    /// 根据count数目返回toolbar底部显示数字或者文字
    ///
    /// - Parameters:
    ///   - count: 数量
    ///   - defaultString: 默认文字：转发、评论、赞
    /// - Returns: 显示出的文字
    func countString(count: Int, defaultString: String) -> String {
        
        if count == 0 {
            return defaultString
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%0.02f 万", Double(count)/10000)
    }
    
    var description: String {
        return timeLineModel.description
    }
    
}
