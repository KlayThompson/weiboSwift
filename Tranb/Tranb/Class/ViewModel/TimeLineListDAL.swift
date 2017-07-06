//
//  TimeLineListDAL.swift
//  Tranb
//
//  Created by Kim on 2017/7/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation
/// DAL - Data Access Layer 数据访问层
/// 使命：负责处理数据库和网络数据，给 ListViewModel 返回微博的[字典数组]
/// 在调整系统的时候，尽量做最小化的调整！
class TimeLineListDAL {

    /// 从网络或者本地加载数据
    ///
    /// - Parameters:
    ///   - since_id: since_id
    ///   - max_id: max_id
    ///   - completion: 完成回调
    class func loadTimelineData(since_id: Int64 = 0,max_id: Int64 = 0, completion: @escaping (_ : [[String : AnyObject]]?, _: Bool)->()) {
    
        //获取用户id
        guard let userId = NetWorkManager.shareManager.userInfo.uid else {
            return
        }
        
        //1.检查本地数据库，如果有直接返回
        let array = TTSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        //如果array为空就是没有数据
        if array.count > 0 {
            //有数据
            completion(array, true)
            return
        }
        
        //2.加载网络数据
        NetWorkManager.shareManager.requestTimeLineListData(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            //判断网络错误情况
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            //守护数据
            guard let json = json else {
                completion(nil, isSuccess)
                return
            }
            
            //3.加载完成网络数据之后，将数组字典存在数据库之中
            TTSQLiteManager.shared.updateTimeLine(userid: userId, timelineArray: json)
            
            //4.返回网络数据
            completion(json, isSuccess)
        }
        
    }
    
}
