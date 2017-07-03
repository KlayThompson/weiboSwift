//
//  TTEmotionFlowLayout.swift
//  Tranb
//
//  Created by Kim on 2017/7/3.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// FlowLayout
class TTEmotionFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        //设置每个单元格大小同collectionView的大小一样
        itemSize = collectionView.bounds.size
        ///并在xib中设置了一些属性如item的间距、分页滚动、竖直不显示滚动条
        
        //设置滚动方向
        //水平方向滚动，cell垂直方向布局
        //竖直方向滚动，cell水平方向布局
        scrollDirection = .horizontal
    }
}
