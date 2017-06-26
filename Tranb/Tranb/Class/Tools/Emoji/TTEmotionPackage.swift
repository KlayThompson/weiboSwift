//
//  TTEmotionPackage.swift
//  Tranb
//
//  Created by Kim on 2017/6/26.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import YYModel

class TTEmotionPackage: NSObject {

    /// 表情包的分组名
    var groupName: String?
    /// 背景图片名称
    var bgImageName: String?
    
    /// 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
    var directory: String?
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons = [TTEmotionModel]()
    
    override var description: String {
        return yy_modelDescription()
    }
}
