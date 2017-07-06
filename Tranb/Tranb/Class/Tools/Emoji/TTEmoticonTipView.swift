//
//  TTEmoticonTipView.swift
//  Tranb
//
//  Created by Kim on 2017/7/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTEmoticonTipView: UIImageView {

    init() {
        
        let bundle = TTEmojiManager.shared.bundle
        
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
