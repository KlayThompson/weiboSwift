//
//  UserInfoModel.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/8.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// 用户信息模型
class UserInfoModel: NSObject {

    /// 用户ID
    var uid: String?
    
    /// 用户授权的唯一票据，用于调用微博的开放接口
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数。 Double类型属性给个初始值
    var expires_in: TimeInterval = 0
    
    override var description: String {
    
        return yy_modelDescription()
    }
}
