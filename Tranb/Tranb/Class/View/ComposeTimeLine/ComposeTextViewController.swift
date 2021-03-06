//
//  ComposeTextViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/29.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeTextViewController: UIViewController {

    
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 输入框
    @IBOutlet weak var textView: TTTextView!
    
    /// 发布按钮
    @IBOutlet var sendButton: UIButton!
    
    /// 顶部标题
    @IBOutlet var titleLabel: UILabel!
    
    /// toolbar到底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    //MARK: - 生命周期哦
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    //MARK: - 方法
    func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /// 发布按钮点击
    @IBAction func sendButtonPress(_ sender: Any) {
        
        //遍历筛选字符串
        let text = textView.analyseTextViewText(attriString: textView.attributedText)
        
        let image = UIImage(named: "new_feature_1")
        

        NetWorkManager.shareManager.postStatueToSina(status: text, image: image) { (result, isSuccess) in
            
            let message = isSuccess ? "发布成功" : "网络不行啊"
            SVProgressHUD.showInfo(withStatus: message)
            //关闭视图
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                    self.dismissViewController()
                })
            }
        }
        
    }
    
    /// 键盘变化通知，更新toolbar约束
    func keyboardChange(notify: Notification) {
        
        guard let rect = (notify.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue ,
            let duration = (notify.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSNumber)?.doubleValue else {
            return
        }
        
        //计算偏移的位置
        let offSet = view.bounds.height - rect.origin.y
        //设置约束
        self.toolbarBottomCons.constant = offSet
        //更新
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 表情按钮点击方法：调用出表情面板
    func emoticonKeyboard() {
        /// 设置输入视图
        let inputViewT = TTEmotionInputView.inputView { [weak self] (emoticon) in
            
            self?.textView.insertEmoticonT(emoticon: emoticon)
        }
        //有就设置无
        textView.inputView = textView.inputView == nil ? inputViewT : nil
        
        //刷新输入视图
        textView.reloadInputViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}

extension ComposeTextViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
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
        sendButton.isEnabled = false
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
            
            //添加方法
            if let actionName = dic["actionName"] {
                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
        }
        //多了一个，移除最后一个
        if items.count > 0 {
            items.removeLast()
        }
        toolBar.items = items
    }
}

