//
//  ComposeTypeView.swift
//  Tranb
//
//  Created by Kim on 2017/6/19.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// 发微博界面
class ComposeTypeView: UIView {

    class func composeTypeView() -> ComposeTypeView {
        //xib不设置frame大小为600*600
        let nib = UINib(nibName: "ComposeTypeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nib, options: nil)[0] as! ComposeTypeView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    /// 显示此时图
    func show() {
        //添加视图  添加到跟视图上面
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
    }
    
    //MARK: - actions
    func buttonsPress(button: UIButton) {
        
    }
    
}

// MARK: - 设置界面
private extension ComposeTypeView {

    func setupUI() {
        
        let button = CompsoeTypeButton.compsoeTypeButton(imageName: "tabbar_compose_idea", titleName: "发微博")
        
        button.center = center
        
        addSubview(button)
        
        button.addTarget(self, action: #selector(buttonsPress), for: .touchUpInside)
    }
}
