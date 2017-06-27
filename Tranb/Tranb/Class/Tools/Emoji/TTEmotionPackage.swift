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
    var directory: String? {
    
        didSet {
            
            guard let directory = directory,
                //获取bundle
                let filePath = Bundle.main.path(forResource: "TTEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: filePath),
                //根据bundle获取对应directory下的infoPlist
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                //获取数据，转换成数组
                let array = NSArray(contentsOfFile: infoPath) as? [[String : String]],
                //字典转模型
                let modelArray = NSArray.yy_modelArray(with: TTEmotionModel.self, json: array) as? [TTEmotionModel] else {
                return
            }
            
            //给表情模型目录赋值
            for model in modelArray {
                model.directory = directory
            }
            
            emoticons += modelArray
        }
    }
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons = [TTEmotionModel]()
    
    override var description: String {
        return yy_modelDescription()
    }
}
