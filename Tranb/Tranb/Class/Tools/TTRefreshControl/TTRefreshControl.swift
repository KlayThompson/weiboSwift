//
//  TTRefreshControl.swift
//  Tranb
//
//  Created by Kim on 2017/6/15.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// 可以刷新的临界值
private let TTRefreshOffset: CGFloat = 133

/// 刷新状态
///
/// - Normal: 普通状态，什么不做
/// - Pulling: 超过临界点，放手的话即开始刷新
/// - WillRefresh: 用户超过临界点，并且放手了，即将开始刷新
enum TTRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class TTRefreshControl: UIControl {

    /// 承接父视图
    weak var scrollView: UIScrollView?
    
    lazy var refreshView = TTRefreshView.refreshView()
    
    
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
//        print(height)
        
        //设置frame
        self.frame = CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
        
        //传递刷新视图高度给子视图
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
        
        //判断临界值
        if scrollView.isDragging {//在拖动情况下
            if height > TTRefreshOffset && refreshView.refreshState == .Normal {
                
                //更改刷新状态
                refreshView.refreshState = .Pulling
            } else if height < TTRefreshOffset && refreshView.refreshState == .Pulling {
                
                refreshView.refreshState = .Normal
            }
        } else {
            //表示手松开了  判断是否过临界点
            if refreshView.refreshState == .Pulling {
               beginRefreshing()
                
                //发送刷新数据事件
                sendActions(for: .valueChanged)
            }
            
        }
        
    }
    
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        //再次之前superview还是存在
        super.removeFromSuperview()
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
        guard let scrollView = scrollView else {
            return
        }
        
        //如果正在刷新则返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        //设置刷新状态
        refreshView.refreshState = .WillRefresh
        
        //设置视图偏移
        var inset = scrollView.contentInset
        inset.top += TTRefreshOffset
        scrollView.contentInset = inset
        
        refreshView.parentViewHeight = TTRefreshOffset
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let scrollView = scrollView else {
            return
        }
        
        //如果不是正在刷新则返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        //设置视图偏移
        var inset = scrollView.contentInset
        inset.top -= TTRefreshOffset
        scrollView.contentInset = inset
    }
}

// MARK: - 设置界面
extension TTRefreshControl {
    
    func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
        
        //别忘记设置这个属性
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        //使用vfl布局
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
    }
}
