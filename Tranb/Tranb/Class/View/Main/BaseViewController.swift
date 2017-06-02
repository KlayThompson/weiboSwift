//
//  BaseViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/1.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var navigation = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    lazy var naviItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override var title: String? {
        
        didSet {
            naviItem.title = title
        }
    }

}


// MARK: - 设置界面
extension BaseViewController {
    
    func setupUI() {
        
        view.addSubview(navigation)
        navigation.items = [naviItem]
    }

}
