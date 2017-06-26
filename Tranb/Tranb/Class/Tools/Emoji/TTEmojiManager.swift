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
        
        packages = modelArray
        
        
    }
}
