//
//  BaseViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var navigation = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    lazy var naviItem = UINavigationItem()
    
    var tableView:UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
        setupTableView()
    }
    
    
    /// 设置tableView
    func setupTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: UIScreen.cz_screenHeight()), style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigation)
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
