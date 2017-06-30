//
//  TTEmotionInputView.swift
//  Tranb
//
//  Created by Kim on 2017/6/30.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTEmotionInputView: UIView {

    //底部toolbar
    @IBOutlet weak var toolbar: UIView!
    //基本的collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    class func inputView() -> TTEmotionInputView {
        
        let nib = UINib(nibName: "TTEmotionInputView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! TTEmotionInputView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
