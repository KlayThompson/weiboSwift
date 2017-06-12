//
//  WelcomeView.swift
//  Tranb
//
//  Created by Kim on 2017/6/9.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎界面
class WelcomeView: UIView {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
     class func welcomeView() -> WelcomeView {
    
        let nib = UINib.init(nibName: "WelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WelcomeView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //获取头像字符串，可选的需要守护
        guard let urlString = NetWorkManager.shareManager.userInfo.avatar_hd,
        let url = URL(string: urlString) else {
        
            return
        }
        
        headImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        
        
        
    }
    
    /// 视图添加到WIdow上面，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.layoutIfNeeded()
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 XIB 中布局的位置
        bottomCons.constant = bounds.size.height - 200
        
        //添加动画
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
}
