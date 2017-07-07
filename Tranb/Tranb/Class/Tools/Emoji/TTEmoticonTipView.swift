//
//  TTEmoticonTipView.swift
//  Tranb
//
//  Created by Kim on 2017/7/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import pop

class TTEmoticonTipView: UIImageView {

    /// 上一次选择的表情，如果两次一样则返回
    var preEmoticon: TTEmotionModel?
    
    
    /// 从外面接受表情模型，用来给内部按钮显示
    var emoticon: TTEmotionModel? {
    
        didSet {
        
            if preEmoticon == emoticon {
                return
            }
            
            //设置按钮
            button.setTitle(emoticon?.emoji, for: .normal)
            button.setImage(emoticon?.image, for: .normal)
            
            //设置按钮动画
            let animate = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animate?.fromValue = 30
            animate?.toValue = 8
            animate?.springSpeed = 20
            animate?.springBounciness = 20
            button.layer.pop_add(animate, forKey: nil)
            print("这一说到海还是")
            //记录表情
            preEmoticon = emoticon
        }
    }
    
    
    /// 提示视图内的显示表情按钮
    private lazy var button = UIButton()
    
    /// 构造函数
    init() {
        
        let bundle = TTEmojiManager.shared.bundle
        
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
        //设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        //设置显示表情按钮
        button.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        button.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        button.center.x = bounds.width * 0.5
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
