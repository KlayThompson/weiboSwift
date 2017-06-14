//
//  SizeDefine.swift
//  Tranb
//
//  Created by Kim on 2017/6/14.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height





//定义常亮
//配图视图到外部的间距
let OutMargin = CGFloat(12)
//图片之间内部间距
let InMargin = CGFloat(3)
//配图视图的宽度
let ViewWidth = UIScreen.cz_screenWidth() - 2*OutMargin
//单个图片的宽度
let PicWidth = (ViewWidth - 2*InMargin)/3
