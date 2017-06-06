//
//  VisitorView.swift
//  Tranb
//
//  Created by Kim on 2017/6/2.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    /// 主页imageName = ""
    /// - Parameter param: 存放imageName 和 tipMessage
    var visitorInfo: [String: String]? {
        //didSet重写
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let tipMessage = visitorInfo?["tipMessage"] else {
                    return
            }
            //提示信息
            tipLabel.text = tipMessage
            
            //icon
            if imageName == "" {
                hosueIcon.isHidden = false
                hosueIcon.isHidden = false
                startanimation()
                return
            }
            hosueIcon.isHidden = true
            iconMaskView.isHidden = true
            iconImageView.image = UIImage(named: imageName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startanimation() {
    
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.duration = 15
        animation.repeatCount = MAXFLOAT
        
        //完成之后不删除
        animation.isRemovedOnCompletion = false
        iconImageView.layer.add(animation, forKey: nil)
    }
    
    //创建界面元素
    //icon 转圈的
    lazy var iconImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    //maskView遮盖视图
    lazy var iconMaskView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    //大的houseIcon
    lazy var hosueIcon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    //提示文本
    lazy var tipLabel:UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜对的对的，关注一些人，回这里看看有什么惊喜奥术大师", fontSize: 14, color: UIColor.darkGray)
    
    //登录
    lazy var loginButton:UIButton = UIButton.cz_textButton("登录", fontSize: 14, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    //注册按钮
    lazy var signInButton:UIButton = UIButton.cz_textButton("注册", fontSize: 14, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")

}

// MARK: - 设置界面
extension VisitorView {

    func setupUI() {
        
        backgroundColor = UIColor.cz_color(withHex: 0xededed)
        
        addSubview(iconImageView)
        addSubview(iconMaskView)
        addSubview(hosueIcon)
        addSubview(tipLabel)
        addSubview(loginButton)
        addSubview(signInButton)
        tipLabel.textAlignment = .center
        //取消autoresizing
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //添加约束
        //icon
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        //iconMaskView 使用VFL设置约束
        //views 定义VFL 中的控件和实际名称映射关系["iconMaskView":iconMaskView]
        let dic = ["iconMaskView":iconMaskView , "loginButton":loginButton] as [String : Any]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[iconMaskView]-0-|", options: [], metrics: nil, views: dic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iconMaskView]-(-20)-[loginButton]", options: [], metrics: nil, views: dic))
        
        //house
        addConstraint(NSLayoutConstraint(item: hosueIcon, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: hosueIcon, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        //提示label
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300))
        
        //登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: 20))
       addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110))
       
        //注册按钮
        addConstraint(NSLayoutConstraint(item: signInButton, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: signInButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: signInButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 110))
        
    }
}
