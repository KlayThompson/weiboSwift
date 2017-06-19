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

    //关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    ///存放button的
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 按钮数据数组
    let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    
    class func composeTypeView() -> ComposeTypeView {
        //xib不设置frame大小为600*600
        let nib = UINib(nibName: "ComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nib, options: nil)[0] as! ComposeTypeView
        v.frame = UIScreen.main.bounds
        v.setupUI()
        
        return v
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
    
    //关闭按钮点击
    @IBAction func closeButtonPress(_ sender: Any) {
        
        removeFromSuperview()
    }
    
    
}

// MARK: - 设置界面
private extension ComposeTypeView {

    func setupUI() {
        //强行更新布局
        layoutIfNeeded()
        
        for index in 0..<2 {
            //创建视图
            let view1 = UIView(frame: scrollView.bounds.offsetBy(dx: CGFloat(index) * scrollView.bounds.width, dy: 0))
            
            creatButtons(view: view1, index: index * 6)
            
            //添加到scrollView
            scrollView.addSubview(view1)
        }
        
        //设置scrollView 的contentSize
        scrollView.contentSize = CGSize(width: 2 * scrollView.bounds.width, height: 0)
       
    }
    
    /// 创建按钮
    ///
    /// - Parameters:
    ///   - view: 背景的视图
    ///   - index: 开始的索引
    func creatButtons(view: UIView, index: Int) {
        
        let count = 6
        
        //循环创建按钮
        for i in index..<(count + index) {
            
            if i >= buttonsInfo.count {
                break
            }
            //取出图片和名称
            let dic = buttonsInfo[i]
            
            guard let imageName = dic["imageName"],
                let title = dic["title"] else {
                    continue
            }
            
            //创建button
            let button = CompsoeTypeButton.compsoeTypeButton(imageName: imageName, titleName: title)
            
            view.addSubview(button)
        }
        
        //设置frame
        let buttonSize = CGSize(width: 100, height: 100)
        let margin = (view.bounds.width - 3 * buttonSize.width) / 4
        
        for (i, button) in view.subviews.enumerated() {
            let y:CGFloat = (i > 2) ? view.bounds.height - buttonSize.height : 0
            //行数
            let col = i % 3
            let x = (margin * CGFloat(col + 1)) + buttonSize.width * CGFloat(col)
            
            //设置坐标
            button.frame = CGRect(x: x, y: y, width: buttonSize.width, height: buttonSize.height)
        }
        
    }
    
    
}
