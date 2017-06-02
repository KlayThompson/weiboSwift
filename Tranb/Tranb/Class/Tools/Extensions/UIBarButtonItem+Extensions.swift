//
//  UIBarButtonItem+Extensions.swift
//  Tranb
//
//  Created by Kim on 2017/6/2.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

extension UIBarButtonItem {

    convenience init(title: String, fontSize: CGFloat = 14, target: Any?, action: Selector) {
        
        
        //创建一个button
        let button: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        //便利构造函数，需要调用self.init()
        self.init(customView: button)
    }
    
}
