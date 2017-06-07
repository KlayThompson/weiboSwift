//
//  TimeLineViewModel.swift
//  Tranb
//
//  Created by Kim on 2017/6/7.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/**
    父类的选择：
 -  如果类需要使用KVC或者字典转模型设置对象值，类就需要继承至NSObject
 -  如果类只是包装一些代码逻辑，可以不用任何父类，好处：更加轻量级
 */

/// 微博动态首页数据列表视图模型
class TimeLineViewModel {
    
    /// 存放动态数据数组
    lazy var dataList = [TimeLineModel]()
    
    func requestTimeLineData(completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        NetWorkManager.shareManager.requestTimeLineListData { (json, isSuccess) in
            
            //字典转模型
            guard let array = NSArray.yy_modelArray(with: TimeLineModel.self, json: json ?? []) as? [TimeLineModel] else {
                
                completion(isSuccess)
                return
            }
            
            self.dataList += array
            
            completion(isSuccess)
        }
        
    }
    
}
