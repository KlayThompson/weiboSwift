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
    
    /// 表情面板分页数
    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    ///根据页数来截取分割emoticons数组，如总数38个则：第一页：0-19  第二页：20-37
    func emotionWithMax20(page: Int) -> [TTEmotionModel] {
        
        let maxCount = 20
        let location = page * maxCount
        var length = maxCount
        
        //判断不能数组越界
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange(location: location, length: length)
        
        return (emoticons as NSArray).subarray(with: range) as! [TTEmotionModel]
        
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
