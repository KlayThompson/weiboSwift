//
//  BaseViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    /// 用户登录状态
    lazy var userLogin = false
    
    /// navigationBar
    lazy var navigation = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    /// NavigationItem
    lazy var naviItem = UINavigationItem()
    
    /// TableView
    var tableView:UITableView?
    
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    
    /// 访客字典
    var visitorInfo: [String: String]?
    
    
    lazy var isPullUp = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadData()
    }

    
    /// 加载数据
    func loadData() {
        
        //如果子类不实现则关闭刷新动画
        refreshControl?.endRefreshing()
    }
    
    /// 重写title 的 didSet 方法
    override var title: String? {
        
        didSet {
            naviItem.title = title
        }
    }

}


// MARK: - 设置界面
extension BaseViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        
        setupNavigationBar()
        
        userLogin ? setupTableView() : setupVisitorView()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func setupVisitorView() {
        
        let visitorView = VisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfo
        view.insertSubview(visitorView, belowSubview: navigation)
    }
    
    /// 设置tableView
    func setupTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: UIScreen.cz_screenHeight()), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.insertSubview(tableView!, belowSubview: navigation)
        tableView?.contentInset = UIEdgeInsets(top: navigation.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        //初始化refreshControl
        refreshControl = UIRefreshControl()
        
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    
    /// 设置导航栏
    func setupNavigationBar() {
        view.addSubview(navigation)
        navigation.items = [naviItem]
        //调整渲染颜色
        navigation.barTintColor = UIColor.cz_color(withHex: 0xf6f6f6)
        //        设置标题颜色
        navigation.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension BaseViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //当显示最后一行的时候，开始上拉刷新
        //要获取最底下的数据行数
        
        let section = tableView.numberOfSections - 1
        let row = indexPath.row
        
        
        if section < 0 || row < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section) - 1
        
        if row == count && !isPullUp {
            print("上拉加载")
            
            //更改上啦刷新状态
            isPullUp = true
            
            //获取网络
            loadData()
        }
        
        
        
    }
    
}
