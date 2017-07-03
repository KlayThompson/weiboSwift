//
//  TTEmotionCell.swift
//  Tranb
//
//  Created by Kim on 2017/7/3.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// 表情cell   用来显示一整页的表情，一共20加上一个删除按钮
class TTEmotionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var emoticons: [TTEmotionModel]? {
        
        didSet {
            //先隐藏所有的按钮
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            //取出按钮上设置图片
            for (index,model) in (emoticons ?? []).enumerated() {
                
                let button = contentView.subviews[index] as! UIButton
                button.setImage(model.image, for: .normal)
                button.isHidden = false
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
}

// MARK: - 设置布局
private extension TTEmotionCell {

    func setupUI() {
       
        //定义常量
        let rowCount = 3
        let colCount = 7
        
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 16
        
        let width = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let height = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        
        //遍历创建21 个按钮
        for index in 0..<21 {
            
            let row = index / colCount
            let col = index % colCount
            
            let x = leftMargin + CGFloat(col) * width
            let y = CGFloat(row) * height
            
            
            let button = UIButton()
            button.frame = CGRect(x: x, y: y, width: width, height: height)
            
            contentView.addSubview(button)
        }
    }
}
