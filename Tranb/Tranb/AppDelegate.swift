//
//  AppDelegate.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        let mainTabBar = MainTabBarController()
        
        window?.rootViewController = mainTabBar
        
        window?.makeKeyAndVisible()
        
        //加载app信息
        loadAppInfoFromServer()
        _ = TTSQLiteManager.shared
        //设置一些额外信息
        setupAdditions(application)  
        let ss = TTEmojiManager.shared
        _ = ss.packages.last?.emoticons.first?.image
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {

    func setupAdditions(_ application: UIApplication) {
        
        SVProgressHUD.setMinimumDismissTimeInterval(1.8)
        
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        registeUserNotificationSetting(application)
    }
    
    /// 注册用户通知
    func registeUserNotificationSetting(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.carPlay, .sound, .badge, .alert]) { (success, error) in
                print("授权---"+(success ? "成功" : "\(String(describing: error))"))
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.sound, .badge, .alert], categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
    }
    
}

// MARK: - 从服务器加载应用配置信息
extension AppDelegate {

    func loadAppInfoFromServer() {
        
        //模拟
        DispatchQueue.global().async {
            
            //1.url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            //2.转换为data
            let data = NSData(contentsOf: url!)
            
            //3.写入磁盘
            //先获取沙盒路径
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            //拼接路径
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            //写入沙盒
            data?.write(toFile: jsonPath, atomically: true)
            
            print("写入沙盒成功 \(jsonPath)")
        }
        
    }
}

