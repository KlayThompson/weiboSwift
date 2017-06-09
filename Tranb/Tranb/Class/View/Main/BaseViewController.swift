//
//  BaseViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
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
    
    /// 重写title 的 didSet 方法
    override var title: String? {
        
        didSet {
            naviItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        //用户登录后再进行刷新TimeLine数据
        NetWorkManager.shareManager.userLogin ? loadData() : ()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: USER_LOGIN_SUCCESS), object: nil)
    }

    
    /// 加载数据
    func loadData() {
        
        //如果子类不实现则关闭刷新动画
        refreshControl?.endRefreshing()
    }
    
    func loginSuccess(notify: Notification) {
        
        print("登录成功\(notify)")
        //设置导航栏
        naviItem.leftBarButtonItem = nil
        naviItem.rightBarButtonItem = nil
        
        //利用生命周期
        view = nil
        
        //因为调用viewDidLoad，会再次注册通知，需要移除
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: USER_LOGIN_SUCCESS), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 访客视图登录注册按钮方法
extension BaseViewController {

    func userLoginButtonPress() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_SHOULD_LOGIN), object: nil)
    }
    
    func userSignInButtonPress() {
        print("用户注册")
    }
    
}

// MARK: - 设置界面
extension BaseViewController {
    
     func setupUI() {
        view.backgroundColor = UIColor.cz_random()
        
        setupNavigationBar()
        
        NetWorkManager.shareManager.userLogin ? setupTableView() : setupVisitorView()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func setupVisitorView() {
        
        let visitorView = VisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfo
        view.insertSubview(visitorView, belowSubview: navigation)
        visitorView.loginButton.addTarget(self, action: #selector(userLoginButtonPress), for: .touchUpInside)
        visitorView.signInButton.addTarget(self, action: #selector(userSignInButtonPress), for: .touchUpInside)
        
        //设置导航栏上面登录注册按钮
        naviItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(userSignInButtonPress))
        naviItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(userLoginButtonPress))
    }
    
    /// 设置tableView
    func setupTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: UIScreen.cz_screenHeight()), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.insertSubview(tableView!, belowSubview: navigation)
        tableView?.contentInset = UIEdgeInsets(top: navigation.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        
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
        
        //设置系统导航栏按钮颜色
        navigation.tintColor = UIColor.orange
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
