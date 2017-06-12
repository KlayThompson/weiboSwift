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
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
