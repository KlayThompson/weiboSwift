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
    
    
    /// 请求Timeline数据，由ViewController调用
    ///
    /// - Parameters:
    ///   - isPullUp: 是否是上拉刷新
    ///   - completion: 完成后回调
    func requestTimeLineData(isPullUp: Bool ,completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        //获取第一个微博since_id
        let since_id = isPullUp ? 0 : (dataList.first?.id ?? 0)
        //获取最后一个微博的maxID
        let max_id = isPullUp ? (dataList.last?.id ?? 0) : 0
        
        
        NetWorkManager.shareManager.requestTimeLineListData(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            //字典转模型
            guard let array = NSArray.yy_modelArray(with: TimeLineModel.self, json: json ?? []) as? [TimeLineModel] else {
                
                completion(isSuccess)
                return
            }
            
            print(array.count)
            if isPullUp {
                //在数组后面拼接
                self.dataList += array
            } else {
                //重头开始增加数据
                self.dataList = array + self.dataList
            }
            
            completion(isSuccess)
        }
        
    }
    
}
