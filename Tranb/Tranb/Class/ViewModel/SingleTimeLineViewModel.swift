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
    }
    
    var description: String {
        return timeLineModel.description
    }
    
}
