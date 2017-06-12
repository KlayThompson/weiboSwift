//
//  HomeViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

private let cellID = "CellID"


class HomeViewController: BaseViewController {

    /// 动态首页数据视图模型
    lazy var timeLineViewModel = TimeLineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
    }
    
    override func loadData() {
        
        //加载动态数据
        timeLineViewModel.requestTimeLineData(isPullUp: isPullUp) { (isSuccess) in
            
            //结束菊花动画
            self.refreshControl?.endRefreshing()
            
            //刷新数据
            self.tableView?.reloadData()
            
            //更改刷新状态
            self.isPullUp = false
        }
    }
    
    func test() {
        navigationController?.pushViewController(NewViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationTitlePress(button: UIButton) {
        
        button.isSelected = !button.isSelected
    }

}


// MARK: - TableView数据源代理方法
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineViewModel.dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TimeLineCell
        
        cell.timeLineTextLabel.text = timeLineViewModel.dataList[indexPath.row].text
        
        return cell
    }
}


// MARK: - 设置界面
extension HomeViewController {

    override func setupTableView() {
        super.setupTableView()
        view.backgroundColor = UIColor.cz_random()
        // Do any additional setup after loading the view.
       
        naviItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(HomeViewController.test))
        
        tableView?.register(UINib(nibName: "TimeLineNormalCell", bundle: nil), forCellReuseIdentifier: cellID)
        
        //设置属性
        tableView?.estimatedRowHeight = 300
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
    }
    
    func setupNavigationTitle() {
        
        let userTitle = NetWorkManager.shareManager.userInfo.screen_name
        
        
        let button = HomeTitleButton(title: userTitle)
        
        button.addTarget(self, action: #selector(navigationTitlePress), for: .touchUpInside)

       
        naviItem.titleView = button
    }
}

