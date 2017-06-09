//
//  UserLoginViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/8.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class UserLoginViewController: UIViewController {

    
    /// 使用webView来进行登录授权界面
    lazy var webView = WKWebView()
    
    override func loadView() {
        super.loadView()
        
        view = webView
        //        view.backgroundColor = UIColor.white
        title = "登录微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(backButtonPress))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFillPWD))
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
        
        webView.navigationDelegate = self
    }

    func backButtonPress() {
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    func autoFillPWD() {
        
        let js = "document.getElementById('userId').value = 'sunshinenate@sina.com'; " +
        "document.getElementById('passwd').value = 'fl033690';"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}

// MARK: - WKNavigationDelegate
extension UserLoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString ?? "")
        
        
        if navigationAction.request.url?.absoluteString.hasPrefix(Redirect_uri) == false {
            decisionHandler(.allow)
            return
        }
        
        if navigationAction.request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            backButtonPress()
            decisionHandler(.cancel)
            return
        }
        
        //获取授权码
        let code = navigationAction.request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("获取授权码 ---\(code)")
        
        //获取AccessToken
        NetWorkManager.shareManager.requestAccessToken(code: code) { (isSuccess) in
            
            if isSuccess {
                SVProgressHUD.showInfo(withStatus: "登录成功")
            } else {
                SVProgressHUD.showInfo(withStatus: "网络错误")
            }
        }
        
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
}
