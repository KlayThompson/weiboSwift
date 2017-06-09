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
    /// - Parameters:
    ///   - since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    /// - Parameter completion: 完成回调： statuses数组 和 是否请求成功
    func requestTimeLineListData(since_id: Int64 = 0,max_id: Int64 = 0, completion: @escaping (_ : [[String : AnyObject]]?, _: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //因为返回ID小于或等于max_id的微博，所以当max_id 大于0时候需要减一，才不会数据重复
        let param = ["since_id" : since_id, "max_id" : max_id > 0 ? (max_id - 1) : 0]
        
        
        NetWorkManager.shareManager.requestNetWorkWithToken(url: urlString, params: param as [String : AnyObject]) { (json, isSuccess) in
            
            /// 从json中获取statuses数组
            let statuses = json?["statuses"] as? [[String : AnyObject]]
            completion(statuses, isSuccess)
        }
    }
    
    /// 获取用户未读的微博数量
    ///
    /// - Parameter completion: 获取到的未读微博数量
    func requestUnreadTimeLineCount(completion: @escaping (_ unreadCount: Int)->()) {
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid" : userInfo.uid]
        
        requestNetWorkWithToken(url: urlString, params: params as [String : AnyObject]) { (json, isSuccess) in
            
            print(json ?? "")
            
            let dic = json as? [String : AnyObject]
            
            let count = dic?["status"] as? Int
            completion(count ?? 0)
            
        }
        
    }
}

// MARK: - 获取用户AccessToken
extension NetWorkManager {

    func requestAccessToken(code: String, completion: @escaping (_ isSucces: Bool)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id" : AppKey,
                      "client_secret" : AppSecret,
                      "grant_type" : "authorization_code",
                      "code" : code,
                      "redirect_uri" : Redirect_uri]
        
        requestNetWork(requestMethod: .POST, url: urlString, params: params as [String : AnyObject]) { (json, isSuccess) in
            print("获取AccessToken -----\(String(describing: json))")
            
            //利用YYModel字典转模型
            self.userInfo.yy_modelSet(with: (json as? [String : AnyObject]) ?? [:])
            print(self.userInfo)
            self.userInfo.saveUserInfoToLocalFile()
            
            completion(isSuccess)
        }
    }
}