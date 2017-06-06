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

    lazy var dataList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadData() {
        
        print("开始加载数据")
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token" : "2.00S2cDxCc2XFVCb8e23fc98e0hJlTN"]
        
           
        NetWorkManager.shareManager.requestNetWork(url: urlString, params: params as [String : AnyObject]) { (json, isSuccess) in
            if isSuccess {
                print(json ?? "")
            }
        }
        
        //延迟两秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            print("加载完成")
            for index in 0..<20 {
                
                if self.isPullUp {
                    self.dataList.append("💪💪💪💪" + index.description)
                } else {
                    self.dataList.insert(index.description, at: 0)
                }
                
            }
            
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

}


// MARK: - TableView数据源代理方法
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = dataList[indexPath.row]
        
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
}

