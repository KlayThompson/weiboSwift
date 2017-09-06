//
//  HomeWebViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/29.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class HomeWebViewController: BaseViewController {

    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                let url = URL(string: urlString) else {
                return
            }
            
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    lazy var webView = WKWebView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.navigationDelegate = self
    }
}

// MARK: - WKNavigationDelegate
extension HomeWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
 
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}

// MARK: - 设置界面
extension HomeWebViewController {

    override func setupTableView() {
        //设置webView
        view.addSubview(webView)
        view.insertSubview(webView, belowSubview: navigation)
        //设置contentInsert
        webView.scrollView.contentInset.top = navigation.bounds.height
        
        //设置标题
        naviItem.title = "秒拍视频"
    }
}
