//
//  TTRefreshControl.swift
//  Tranb
//
//  Created by Kim on 2017/6/15.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTRefreshControl: UIControl {

    /// 承接父视图
    weak var scrollView: UIScrollView?
    
    
    // MARK: 构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    /// 在addSubView时候会调用该方法
    /// 在父视图被销毁的时候还会调用
    /// - Parameter newSuperview:addSubView时候为父视图，被销毁时候为nil
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let newSuperview = newSuperview as? UIScrollView else {
            return
        }
        //记录父视图
        scrollView = newSuperview
        
        //KVO监听父视图的contentOffSet
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    /// KVO监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(scrollView?.contentOffset ?? 0.0)
        //初始高度应该为0
        guard let scrollView = scrollView else {
            return
        }
        let height = -(scrollView.contentInset.top + scrollView.contentOffset.y)
        print(height)
        
        //设置frame
        self.frame = CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
        
    }
    
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        //再次之前superview还是存在
        super.removeFromSuperview()
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
    }
    
    /// 结束刷新
    func endRefreshing() {
        
    }
}

// MARK: - 设置界面
extension TTRefreshControl {
    
    func setupUI() {
        backgroundColor = UIColor.cyan
    }
}
