//
//  TTLabel.swift
//  Tranb
//
//  Created by Kim on 2017/6/28.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTLabel: UILabel {

    /// 属性文本存储
    lazy var textStorage = NSTextStorage()
    
    /// 负责文本字形布局
    lazy var layoutManger = NSLayoutManager()
    
    /// 设置文本绘制的范围
    lazy var textContainer = NSTextContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
    }
    
    //接管
    override func drawText(in rect: CGRect) {
        
        let range = NSRange(location: 0, length: textStorage.length)
        
        layoutManger.drawGlyphs(forGlyphRange: range, at: CGPoint())
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //制定文本的区域
        textContainer.size = bounds.size
    }
}

// MARK: - 设置TextKit的核心对象
private extension TTLabel {
    
    /// 准备文本系统
    func prepareTextSystem() {
        
        //1.准备文本内容
        preparTextContent()
        //2.设置对象的关系
        layoutManger.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManger)
        
    }
    
    /// 准备文本内容 - 使用textStorage接管label的内容
    func preparTextContent() {
        
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        } else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        } else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
    }
}
