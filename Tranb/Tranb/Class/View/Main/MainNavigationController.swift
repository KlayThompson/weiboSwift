//
//  MainNavigationController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //不是根控制器就hide
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            //增加返回按钮---如果是childViewControllers中只有一个就显示标题，其他的都显示返回
            var title = "返回"
            //首先取出控制器
            if let vc = viewController as? BaseViewController {
                
                //判断是否是第一个
                if childViewControllers.count == 1 {
                    
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.naviItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(MainNavigationController.goBack))
            }
            
          
            
        }
        super.pushViewController(viewController, animated: animated)
        
    }
    
    @objc private func goBack() {
        
        popViewController(animated: true)
    }

}
