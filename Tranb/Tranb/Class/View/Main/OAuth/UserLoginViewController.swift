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
    
    override func loadView() {
        super.loadView()
        
        view = webView
        //        view.backgroundColor = UIColor.white
        title = "登录微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(backButtonPress))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(Redirect_uri)"
        print(urlString)
        
        /// 因为url可能为空，所以使用guard守护一下
        guard let url = URL(string: urlString) else {
            print("URL为空，请检查----")
            return;
        }
        
        
        let request = URLRequest(url: url)
        
        //jiazai
        webView.load(request)
    }

    func backButtonPress() {
        dismiss(animated: true, completion: nil)
    }
}
