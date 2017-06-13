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
        pictureSize = calulatorPictureSize(imageCount: model.pic_urls?.count)
    }
    
    /// 计算微博配图视图整体的尺寸
    ///
    /// - Parameter imageCount: 微博配图的数量
    /// - Returns: return 微博配图视图整体的尺寸
    func calulatorPictureSize(imageCount: Int?) -> CGSize {
        
        
        return CGSize(width: 200, height: 304)
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
