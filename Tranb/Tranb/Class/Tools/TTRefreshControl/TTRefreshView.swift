//
//  TTRefreshView.swift
//  Tranb
//
//  Created by Kim on 2017/6/16.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTRefreshView: UIView {

    /// 箭头的icon
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 提示下拉刷新文字
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 菊花
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    //刷新状态
    var refreshState: TTRefreshState = .Normal
    
    
    
    class func refreshView() -> TTRefreshView {
    
        let nib = UINib(nibName: "TTRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! TTRefreshView
    }
    
}
