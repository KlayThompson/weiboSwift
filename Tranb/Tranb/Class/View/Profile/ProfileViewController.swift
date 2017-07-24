//
//  ProfileViewController.swift
//  Tranb
//
//  Created by Kim on 2017/7/21.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController,WeiboSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func weiboLogin(_ sender: Any) {
        
        if !WeiboSDK.isWeiboAppInstalled() {
            return
        }
        
        let request = WBAuthorizeRequest()
        request.redirectURI = "http://www.baidu.com"
        request.scope = "all"
      
        
        
        
        WeiboSDK.send(request)
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        print("wqwerewqwewq")
    }
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        print("asdfasdf")
    }
    
    @IBAction func loginButtonPress(_ sender: Any) {
        
        if !WXApi.isWXAppInstalled() {
            return
        }
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "App"
        WXApi.send(req)
    }
}


extension ProfileViewController {

    override func setupTableView() {
        
    }
    
}
