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
    
    //表情包bundle
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "TTEmoticon.bundle", ofType: nil)
        //获取bundle
        return Bundle(path: path!)!
    }()
    
    private init() {
        loadLocalEmojiData()
    }
}

// MARK: - 筛选表情
extension TTEmojiManager {
    
    func emotionString(string: String, font: UIFont) -> NSAttributedString {
        
        //转换字符串NSMutableAttributedString
        let attrString = NSMutableAttributedString(string: string)
        //建立正则表达式，检索所有表情
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        //匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        //遍历所有匹配结果 倒叙才能正确全部匹配
        for chr in matches.reversed() {
            let range = chr.range
            
            let subString = (attrString.string as NSString).substring(with: range)
            //查找对应的表情符号
            if let emotion = TTEmojiManager.shared.findEmotions(string: subString) {
                //替换
                attrString.replaceCharacters(in: range, with: emotion.imageText(font: font))
            }
        }
        
        //统一设置字体属性 必须设置的，要不然后导致界面布局错乱  颜色也需要设置
        attrString.addAttributes([NSFontAttributeName: font], range: NSRange.init(location: 0, length: attrString.length))
        
        return attrString
    }

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
        guard
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
