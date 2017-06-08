//
//  UserLoginViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/8.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import WebKit

class UserLoginViewController: UIViewController {

    
    /// 使用webView来进行登录授权界面
    lazy var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = webView
//        view.backgroundColor = UIColor.white
        title = "登录微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(backButtonPress))

    }

    func backButtonPress() {
        dismiss(animated: true, completion: nil)
    }
}
