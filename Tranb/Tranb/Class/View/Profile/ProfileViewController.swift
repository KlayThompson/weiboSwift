//
//  ProfileViewController.swift
//  Tranb
//
//  Created by Kim on 2017/7/21.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
