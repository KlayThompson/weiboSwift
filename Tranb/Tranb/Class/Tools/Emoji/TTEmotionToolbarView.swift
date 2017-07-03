//
//  TTEmotionToolbarView.swift
//  Tranb
//
//  Created by Kim on 2017/6/30.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTEmotionToolbarView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //计算常量
        let width = bounds.width / CGFloat(subviews.count)
        
        
        //遍历子视图，设置frame
        for (index, button) in subviews.enumerated() {
            
            button.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: bounds.height)
            
        }
    }

}

private extension TTEmotionToolbarView {

    func setupUI() {
        
        //设置按钮
        let manager = TTEmojiManager.shared
        
        //遍历所有表情包组
        for group in manager.packages {
            
            //创建button
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitle(group.groupName, for: .normal)
            
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .highlighted)
            button.setTitleColor(UIColor.darkGray, for: .selected)
            
            //设置背景图片
            let imageName = "compose_emotion_table_\(group.bgImageName ?? "")_normal"
            let imageNameSelected = "compose_emotion_table_\(group.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageSelected = UIImage(named: imageNameSelected, in: manager.bundle, compatibleWith: nil)
            //设置拉伸
            let size = image?.size ?? CGSize()
            let insets = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
            
            image = image?.resizableImage(withCapInsets: insets)
            imageSelected = imageSelected?.resizableImage(withCapInsets: insets)
            
            button.setBackgroundImage(image, for: .normal)
            button.setBackgroundImage(imageSelected, for: .selected)
            button.setBackgroundImage(imageSelected, for: .highlighted)
            
            button.sizeToFit()
            
            addSubview(button)
        }
        
    }
}
