//
//  TimeLineModel.swift
//  Tranb
//
//  Created by Kim on 2017/6/7.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import YYModel

class TimeLineModel: NSObject {

    
    /// 微博ID， 需要使用Int64，要不然在低端机器上会溢出
    var id: Int64 = 0
    
    /// 微博内容
    var text: String?
    
    /// 用户信息模型
    var user: UserInfoUnit?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 点赞数
    var attitudes_count: Int = 0
    
    /// 微博配图模型
    var pic_urls: [TimeLinePictureUnit]?
    
    /// 被转发的原微博信息字段，当该微博为转发微博时返回
    var retweeted_status: TimeLineModel?
    
    /// 微博创建时间
    var created_at: String?
    
    /// 微博来源
    var source: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        
        return ["pic_urls" : TimeLinePictureUnit.self]
    }
}
