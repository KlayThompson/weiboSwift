//
//  TTEmojiManager.swift
//  Tranb
//
//  Created by Kim on 2017/6/26.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/// 表情管理单利
class TTEmojiManager {
    
    static let shared = TTEmojiManager()
    
    /// 表情包数据
    lazy var packages = [TTEmotionPackage]()
    
    private init() {
        loadLocalEmojiData()
    }
}

// MARK: - 筛选表情
extension TTEmojiManager {

    func findEmotions(string: String) -> TTEmotionModel? {
        
        //遍历表情包
        for emotion in packages {
            //在表情数组中过滤string
            let array = emotion.emoticons.filter({ (model) -> Bool in
                return model.chs == string
            })
            
            //判断结果数组的数量
            if array.count == 1 {
                return array[0]
            }
        }
        
    
        
        return nil
    }
}

// MARK: - 加载本地数据
private extension TTEmojiManager {
    
    func loadLocalEmojiData() {
        
        //从plist文件中读取数据
        guard let path = Bundle.main.path(forResource: "TTEmoticon.bundle", ofType: nil),
            //获取bundle
            let bundle = Bundle(path: path),
            //根据这个bundle来获取所需要的plist
            let emojipPlistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            //转换成数组
            let emotionsArray = NSArray(contentsOfFile: emojipPlistPath) as? [[String : String]],
            //字典转模型
            let modelArray = NSArray.yy_modelArray(with: TTEmotionPackage.self, json: emotionsArray) as? [TTEmotionPackage] else {
                
            return
        }
        //使用+=不需要为package重新分配空间，直接追加数据
        packages += modelArray
    }
}
