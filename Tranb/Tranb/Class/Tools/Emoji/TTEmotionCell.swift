//
//  TTEmotionCell.swift
//  Tranb
//
//  Created by Kim on 2017/7/3.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

//定义代理传递模型到上一个界面
protocol TTEmotionCellDelegate: NSObjectProtocol {

    /// 选中了表情按钮
    ///
    /// - Parameter emoticon: emoticon为空为删除按钮，不为空就为表情按钮
    func cellDidSelectedEmoticon(cell: TTEmotionCell, emoticon: TTEmotionModel?)
}

/// 表情cell   用来显示一整页的表情，一共20加上一个删除按钮
class TTEmotionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    weak var delegate: TTEmotionCellDelegate?
    
    var emoticons: [TTEmotionModel]? {
        
        didSet {
            //先隐藏所有的按钮
            for v in contentView.subviews {
                v.isHidden = true
            }
            //显示删除按钮
            contentView.subviews.last?.isHidden = false
            
            //取出按钮上设置图片
            for (index,model) in (emoticons ?? []).enumerated() {
                
                let button = contentView.subviews[index] as! UIButton
                button.setImage(model.image, for: .normal)
                button.isHidden = false
                
                //设置emoji字符串
                button.setTitle(model.emoji, for: .normal)
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
    
    //MARK: - 按钮方法
    func emoticonButtonPress(button: UIButton) {
        //取出tag
        let tag = button.tag
        
        //取出emotion
        var emoticon: TTEmotionModel?
        if tag < emoticons?.count ?? 0 {
            emoticon = emoticons?[tag]
        }
        
        //如果为空就是删除，其他为表情
        delegate?.cellDidSelectedEmoticon(cell: self, emoticon: emoticon)
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
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            //添加监听方法
            button.tag = index
            button.addTarget(self, action: #selector(emoticonButtonPress), for: .touchUpInside)
            
            contentView.addSubview(button)
        }
        
        ///设置删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        
        removeButton.setImage(UIImage(named: "compose_emotion_delete", in: TTEmojiManager.shared.bundle, compatibleWith: nil), for: .normal)
    }
}
