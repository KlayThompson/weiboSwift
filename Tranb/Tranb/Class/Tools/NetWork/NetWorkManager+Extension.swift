//
//  NetWorkManager+Extension.swift
//  Tranb
//
//  Created by Kim on 2017/6/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation


// MARK: - 封装微博网络接口（我觉着不好，待验证）
extension NetWorkManager {

    
    /// 封装请求TimeLine数据
    ///
    /// - Parameter completion: 完成回调： statuses数组 和 是否请求成功
    func requestTimeLineListData(completion: @escaping (_ : [[String : AnyObject]]?, _: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        
        NetWorkManager.shareManager.requestNetWorkWithToken(url: urlString, params: [:] as [String : AnyObject]) { (json, isSuccess) in
            
            /// 从json中获取statuses数组
            let statuses = json?["statuses"] as? [[String : AnyObject]]
            completion(statuses, isSuccess)
        }
    }
}
