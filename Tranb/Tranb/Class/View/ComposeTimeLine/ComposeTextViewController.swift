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
        
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }

    func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPress(_ sender: Any) {
    }
    
    func keyboardChange() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
}

// MARK: - 设置界面
private extension ComposeTextViewController {
    
    func setupUI() {
        
        setupNavigationBar()
        setupToolbar()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
    }
    
    func setupToolbar() {
        
        let itemImages = [["imageName": "compose_toolbar_picture"],
                          ["imageName": "compose_mentionbutton_background"],
                          ["imageName": "compose_trendbutton_background"],
                          ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                          ["imageName": "compose_add_background"]]

        var items = [UIBarButtonItem]()
        
        
        for dic in itemImages {
            
            guard let imageName = dic["imageName"] else {
                continue
            }
            
            //创建button
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: imageName), for: .normal)
            button.setBackgroundImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            button.sizeToFit()
            
            items.append(UIBarButtonItem(customView: button))
            
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //多了一个，移除最后一个
        if items.count > 0 {
            items.removeLast()
        }
        toolBar.items = items
    }
}

