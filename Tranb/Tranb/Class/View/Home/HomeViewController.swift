//
//  HomeViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

private let cellID = "CellID"
private let reTweetCellID = "retweetCellID"

class HomeViewController: BaseViewController {

    /// 动态首页数据视图模型
    lazy var timeLineViewModel = TimeLineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
    }
    
    override func loadData() {
        self.refreshControl?.beginRefreshing()
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
        navigationController?.pushViewController(TestnewViewController(), animated: true)
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
        
        let singleTimeLineViewModel = timeLineViewModel.dataList[indexPath.row]
        //判断有没有转发微博，来使用不同cell
        let id = (singleTimeLineViewModel.timeLineModel.retweeted_status != nil) ? reTweetCellID : cellID
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TimeLineCell
        cell.viewModel = singleTimeLineViewModel
        
        //设置cell代理
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = timeLineViewModel.dataList[indexPath.row]
        return viewModel.rowHeight
    }
}

extension HomeViewController: TimeLineCellDelegate {

    func timeLineDidSelectUrlString(cell: TimeLineCell, urlString: String) {
        
        let homeWeb = HomeWebViewController()
        homeWeb.urlString = urlString
        navigationController?.pushViewController(homeWeb, animated: true)
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
        tableView?.register(UINib(nibName: "TimeLineRetweetCell", bundle: nil), forCellReuseIdentifier: reTweetCellID)
        
        //设置属性
        tableView?.estimatedRowHeight = 300
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
    }
    
    func setupNavigationTitle() {
        
        let userTitle = NetWorkManager.shareManager.userInfo.screen_name
        
        
        let button = HomeTitleButton(title: userTitle)
        
        button.addTarget(self, action: #selector(navigationTitlePress), for: .touchUpInside)

       
        naviItem.titleView = button
    }
}

