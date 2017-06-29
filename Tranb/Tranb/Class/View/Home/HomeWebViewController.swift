//
//  HomeWebViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/29.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import WebKit
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
        
        // Do any additional setup after loading the view.
    }
}

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
