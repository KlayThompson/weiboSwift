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
    @IBOutlet weak var iconImageView: UIImageView?
    
    /// 提示下拉刷新文字
    @IBOutlet weak var tipLabel: UILabel?
    
    /// 菊花
    @IBOutlet weak var indicatorView: UIActivityIndicatorView?
    
    //刷新状态
    var refreshState: TTRefreshState = .Normal {
    
        didSet {
            switch refreshState {
            case .Normal:
                tipLabel?.text = "继续加把劲啊"
                UIView.animate(withDuration: 0.35, animations: { 
                    self.iconImageView?.transform = CGAffineTransform.identity
                })
                //设置一些
                iconImageView?.isHidden = false
                indicatorView?.stopAnimating()
            case .Pulling:
                tipLabel?.text = "放开我就刷新"
                UIView.animate(withDuration: 0.35, animations: {
                    self.iconImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(.pi + 0.001))
                })
            case .WillRefresh:
                tipLabel?.text = "我在刷新了"
                //隐藏箭头
                iconImageView?.isHidden = true
                //显示菊花
                indicatorView?.startAnimating()
            }
        }
    }
    
    //父视图高度
    var parentViewHeight: CGFloat = 0
    
    
    
    class func refreshView() -> TTRefreshView {
    
        let nib = UINib(nibName: "TTMTRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! TTRefreshView
    }
    
}
