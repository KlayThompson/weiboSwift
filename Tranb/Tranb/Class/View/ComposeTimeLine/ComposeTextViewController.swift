//
//  ComposeTextViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/29.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class ComposeTextViewController: UIViewController {

    
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 输入框
    @IBOutlet weak var textView: UITextView!
    
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    
    /// 顶部标题
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupUI()
        
    }

    func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPress(_ sender: Any) {
    }
}

private extension ComposeTextViewController {

    func setupUI() {
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
    }
}
