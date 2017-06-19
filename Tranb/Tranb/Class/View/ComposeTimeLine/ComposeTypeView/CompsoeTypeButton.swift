//
//  CompsoeTypeButton.swift
//  Tranb
//
//  Created by Kim on 2017/6/19.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class CompsoeTypeButton: UIControl {

    /// 按钮图片
    @IBOutlet weak var imageView: UIImageView!
    
    /// 按钮文字
    @IBOutlet weak var titleLabel: UILabel!
  
    class func compsoeTypeButton(imageName: String, titleName: String) -> CompsoeTypeButton {
    
        let nib = UINib(nibName: "CompsoeTypeButton", bundle: nil)
        
        let button = nib.instantiate(withOwner: nil, options: nil)[0] as! CompsoeTypeButton
        
        button.imageView.image = UIImage(named: imageName)
        
        button.titleLabel.text = titleName
        
        return button
    }

}
