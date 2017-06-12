//
//  SingleTimeLineViewModel.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/12.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/// 单个微博视图模型
class SingleTimeLineViewModel {
    
    var timeLineModel: TimeLineModel
    
    /// 返回单个微博的视图模型
    ///
    /// - Parameter model: TimeLineModel
    init(model: TimeLineModel) {
        self.timeLineModel = model
    }
    
}
