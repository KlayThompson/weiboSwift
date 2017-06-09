//
//  HomeTitleButton.swift
//  Tranb
//
//  Created by Kim on 2017/6/9.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class HomeTitleButton: UIButton {

    
    /// 重载构造函数
    ///
    /// - Parameter title: title为空则显示首页
    init(title: String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        //设置字体属性
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        setTitleColor(UIColor.darkGray, for: .normal)
        
        //设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
            let imageView = imageView
            else {
            return
        }
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width
    }
    
}
