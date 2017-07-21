//
//  TTTextView.swift
//  Tranb
//
//  Created by Kim on 2017/6/30.
//  Copyright © 2017年 KlayThompson. All rights  		.
//

import UIKit

class TTTextView: UITextView {

    lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: - 方法
    func textViewDidChange() {
        placeholderLabel.isHidden = self.hasText
    }
}

extension TTTextView {

    
    /// 插入表情符号
    ///
    /// - Parameter emoticon: emoticon 为空就是删除，不为空就是表情模型
    func insertEmoticonT(emoticon: TTEmotionModel?) {
        
        //判断是删除则执行删除
        guard let emoticon = emoticon else {
            
            deleteBackward()
            return
        }
        
        //emoji 处理emoji的显示输入。。
        if let emoji = emoticon.emoji, let range = selectedTextRange {
            
            replace(range, withText: emoji)
            return
        }
        
        //图片表情
        //1.将当前图像转换为属性文本
        let imageAtt = emoticon.imageText(font: font!)
        
        //2.将界面上的属性文本转换为可变属性文本，让扁后面插入
        let attriString = NSMutableAttributedString(attributedString: attributedText)
        
        //3.将表情图片的属性文本插入可变的属性文本
        attriString.replaceCharacters(in: selectedRange, with: imageAtt)
        
        //4.重新给textView的属性文本赋值
        //记录光标位置
        let range = selectedRange
        //赋值
        attributedText = attriString
        //恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
        //执行代理
        delegate?.textViewDidChange?(self)
        textViewDidChange()
        
    }
    
    func analyseTextViewText(attriString: NSAttributedString) -> String {
        
        
        /// 结果
        var result = String()
        
        //遍历属性文本
        attriString.enumerateAttributes(in: NSRange(location: 0, length: attriString.length), options: []) { (dic, range, _) in
            //如果字典中包含NSAttachment 说明是图片
            if let attechment = dic["NSAttachment"] as? TTEmoticonAttachment {
                result += attechment.chs ?? ""
            } else {
                let subString = (attriString.string as NSString).substring(with: range)
                result += subString
            }
        }
        
        print(result)
        return result
    }
}

// MARK: - 设置界面
private extension TTTextView {

    func setupUI() {
        
        //注册通知，监听TextView文本信息
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 6)
        placeholderLabel.font = self.font
        addSubview(placeholderLabel)
    }
}
