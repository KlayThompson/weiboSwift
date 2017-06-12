//
//  UserInfoUnit.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/12.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class UserInfoUnit: NSObject {

    /// 用户ID
    var id: Int64 = 0
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 认证类型：-1 没有认证，0认证用户，2，3，5企业认证， 220达人
    var verified_type: Int = 0
    
    /// 会员等级，0-6
    var mbrank: Int = 0
    
    override var description: String {
    
        return yy_modelDescription()
    }
    
}
