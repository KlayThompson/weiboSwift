//
//  UIBarButtonItem+Extensions.swift
//  Tranb
//
//  Created by Kim on 2017/6/2.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

extension UIBarButtonItem {

    /// 自定义UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize 默认16号
    ///   - target: target
    ///   - action: action
    ///   - isBack: isBack 是否是返回按钮，默认不是
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        
        
        //创建一个button
        let button: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let backImageName = "navigationbar_back_withtext"
            
            button.setImage(UIImage.init(named: backImageName), for: .normal)
            button.setImage(UIImage.init(named: backImageName + "_highlighted"), for: .highlighted)
            //重新调整按钮大小
            button.sizeToFit()
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        //便利构造函数，需要调用self.init()
        self.init(customView: button)
    }
    
}
