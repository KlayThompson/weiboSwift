//
//  TTEmotionModel.swift
//  Tranb
//
//  Created by Kim on 2017/6/26.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation
import YYModel

class TTEmotionModel: NSObject {
    
    /// 表情类型 false - 图片表情 / true - emoji
    var type = false
    /// 表情字符串，发送给新浪微博的服务器(节约流量)
    var chs: String?
    /// 表情图片名称，用于本地图文混排
    var png: String?
    /// emoji 的十六进制编码
    var code: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
