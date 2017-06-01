//
//  MainTabBarController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cz_random()
        // Do any additional setup after loading the view.
        setupChildViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MainTabBarController {
    
    ///设置子控制器
    func setupChildViewController() {
        
        //创建一个存放字典的数组
        let dicArray = [
            ["className" : "HomeViewController", "title" : "首页", "imageName" : "tabbar_home"],
            ["className" : "MessageViewController", "title" : "消息", "imageName" : "tabbar_message_center"],
            ["className" : "DiscoveryViewController", "title" : "发现", "imageName" : "tabbar_discover"],
            ["className" : "ProfileViewController", "title" : "我", "imageName" : "tabbar_profile"],
        ]
        
        //创建一个存放viewcontroller的数组
        var vcArray = [UIViewController]()
        
        //遍历dicArray
        for dic in dicArray {
            vcArray.append(viewController(dictionary: dic))
        }
        
        viewControllers = vcArray
    }
    
    
    /// 使用字典创建子控制器
    ///
    /// - Parameter dictionary: 关于viewcontroller等相关参数 name、imageName、className
    /// - Returns: UIviewcontroller
    func viewController(dictionary: [String: String]) -> UIViewController {
        
        
        guard let className = dictionary["className"],
            let imageName = dictionary["imageName"],
            let title = dictionary["title"],
        let clas = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type
            else {
        
                return UIViewController()
        }
        
        let viewConttroller = clas.init()
        
        //设置标题
        viewConttroller.title = title
        viewConttroller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        viewConttroller.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        //设置tabbar image
        viewConttroller.tabBarItem.image = UIImage(named: imageName)
        viewConttroller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        
        
        let navi = MainNavigationController(rootViewController: viewConttroller)
        
        return navi
    }
    
}
