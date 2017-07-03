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
    var code: String? {
        didSet {
            //转换成string
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            
            scanner.scanHexInt32(&result)
            
            guard let unicode = UnicodeScalar(result) else {
                return
            }
            
            emoji = String(Character(unicode))
        }
    }
    
    /// emoji字符串
    var emoji: String?
    
    
    /// 表情模型所在目录
    var directory: String?
    
    /// 图片表情对应的图像
    var image: UIImage? {
    
        guard let path = Bundle.main.path(forResource: "TTEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let png = png,
            let directory = directory else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    
    /// 将当前图像转换成图像的属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        //确保图片存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        //创建文本附件
        let att = NSTextAttachment()
        att.image = image
        let height = font.lineHeight
        att.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        
        return NSAttributedString(attachment: att)
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
