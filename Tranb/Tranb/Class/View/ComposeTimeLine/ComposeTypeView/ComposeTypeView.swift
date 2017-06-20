//
//  ComposeTypeView.swift
//  Tranb
//
//  Created by Kim on 2017/6/19.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import pop

/// 发微博界面
class ComposeTypeView: UIView {

    //关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    ///存放button的
    @IBOutlet weak var scrollView: UIScrollView!
    //箭头返回按钮
    @IBOutlet weak var backButtton: UIButton!
    //返回箭头按钮竖直居中位置
    @IBOutlet weak var backButtonCenterXCons: NSLayoutConstraint!
    //关闭按钮竖直居中位置
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    //毛玻璃视图
    @IBOutlet weak var effectView: UIVisualEffectView!
    /// 按钮数据数组
    let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多","actionName" : "moreButtonPress"],
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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    

    /// 显示此时图
    func show() {
        //添加视图  添加到跟视图上面
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        
        showCurrentView()
    }
    
    //MARK: - actions
    func buttonsPress(button: UIButton) {
        
    }
    
    //关闭按钮点击
    @IBAction func closeButtonPress(_ sender: Any) {
        
        removeFromSuperview()
    }
    
    //点击更多按钮
    func moreButtonPress() {
        print("点击更多")
        //滚动到第二页
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        //设置底部按钮
        backButtton.isHidden = false
        
        //设置偏移
        let offSet = scrollView.bounds.width / 4
        
        closeButtonCenterXCons.constant += offSet
        backButtonCenterXCons.constant -= offSet
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    //返回箭头按钮点击
    @IBAction func backButtonPress(_ sender: Any) {
        //返回到第一页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //让两个按钮合并
        closeButtonCenterXCons.constant = 0
        backButtonCenterXCons.constant = 0
        UIView.animate(withDuration: 0.3, animations: { 
            self.layoutIfNeeded()
            self.backButtton.alpha = 0
        }) { (_) in
            self.backButtton.isHidden = true
            self.backButtton.alpha = 1
        }
        
    }
    
    
}

// MARK: - 设置动画
private extension ComposeTypeView {

    func showCurrentView() {
        
        let animate: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animate.fromValue = 0
        animate.toValue = 1
        animate.duration = 0.5
        //添加到毛玻璃视图上面，如果直接添加到此view上会有莫名卡顿，应该是背景颜色是clear导致的
        effectView.pop_add(animate, forKey: nil)
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
            
            //添加点击事件
            if let actionName = dic["actionName"] {
                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
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
