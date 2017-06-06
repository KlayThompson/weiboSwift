//
//  MainTabBarController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupChildViewController()
        setupComposeButton()
        
    }

    
    
    
    func composeButtonPress() {
        print("发微博")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - TabbarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let _ = item.title else {
            
            composeButtonPress()
            return
        }
    }
    
    
    /// 控制设备横竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


// MARK: - 设置界面
extension MainTabBarController {
    
    //设置发布按钮
    func setupComposeButton() {
        tabBar.addSubview(composeButton)
        //计算tabbar宽度
        let tabBarWidth = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = tabBar.bounds.insetBy(dx: tabBarWidth * 2, dy: 0)
        composeButton.addTarget(self, action: #selector(MainTabBarController.composeButtonPress), for: .touchUpInside)
    }
    
    ///设置子控制器
    func setupChildViewController() {
        
        //1.获取沙河路径
        let docDir = NSSearchPathForDirectoriesInDomains(.adminApplicationDirectory, .localDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathExtension("main.json")
        
        //加载data
        var data = NSData(contentsOfFile: jsonPath ?? "")
        
        //判断data是否存在，不存在则从本地文件获取
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path ?? "")
        }
        
        
        
        guard let dicArray = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]] else {
            return
        }
        
        

        
        //测试数据格式是否正确
//        (dicArray as NSArray).write(toFile: "/Users/klaythompson/Desktop/demo.plist", atomically: true)
        
        //数组到json序列化
//        let data = try! JSONSerialization.data(withJSONObject: dicArray, options: [.prettyPrinted])
//        
//        (data as NSData).write(toFile: "/Users/kim/Desktop/main.json", atomically: true)
        
        //创建一个存放viewcontroller的数组
        var vcArray = [UIViewController]()
        
        //遍历dicArray
        for dic in dicArray! {
            vcArray.append(viewController(dictionary: dic))
        }
        
        viewControllers = vcArray
    }
    
    
    /// 使用字典创建子控制器
    ///
    /// - Parameter dictionary: 关于viewcontroller等相关参数 name、imageName、className
    /// - Returns: UIviewcontroller
    func viewController(dictionary: [String: AnyObject]) -> UIViewController {
        
        
        guard let className = dictionary["className"] as? String,
            let imageName = dictionary["imageName"] as? String,
            let title = dictionary["title"] as? String,
            let clas = NSClassFromString(Bundle.main.namespace + "." + className) as? BaseViewController.Type,
            let visitorInfo = dictionary["visitorInfo"]
        
            else {
        
                return UIViewController()
        }
        
        let viewConttroller = clas.init()
        
        viewConttroller.visitorInfo = visitorInfo as? [String : String]
        
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
