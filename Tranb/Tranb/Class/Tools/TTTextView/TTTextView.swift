//
//  TTTextView.swift
//  Tranb
//
//  Created by Kim on 2017/6/30.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTTextView: UITextView {

    lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: - 方法
    func textViewDidChange(notify: Notification) {
        placeholderLabel.isHidden = self.hasText
    }
}

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
