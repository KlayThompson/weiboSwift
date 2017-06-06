//
//  NetWorkManager.swift
//  Tranb
//
//  Created by Kim on 2017/6/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import AFNetworking//直接导入文件夹名称


/// 发起网络请求枚举类型
///
/// - GET: GET请求
/// - POST: POST请求
enum RequestMethod {
    case GET
    case POST
}

class NetWorkManager: AFHTTPSessionManager {

    
    //创建单利
    static let shareManager = NetWorkManager()
    
    
    /// 封装的post 和 get 网络请求
    ///
    /// - Parameters:
    ///   - requestMethod: post或者get
    ///   - url: url字符串
    ///   - params: 请求参数
    ///   - completion: 完成回调json数据和isSuccess是否成功
    func requestNetWork(requestMethod: RequestMethod = .GET, url: String, params: [String: AnyObject], completion: @escaping (_ resultJson: AnyObject?, _ isSuccess: Bool) -> ()) {
     
        //创建闭包
        let success = { (dataTask: URLSessionDataTask, json: Any?) -> () in
            completion(json as AnyObject, true)
        }
        
        let failure = { (dataTask: URLSessionDataTask?, error: Error) -> () in
            completion(nil, false)
            
            print("网络请求错误-----\(error)")
        }
        
        
        
        if requestMethod == .GET {
            get(url, parameters: params, progress: nil, success: success, failure: failure)
        } else {
            post(url, parameters: params, progress:nil, success: success, failure: failure)
        }
        
    }
    
}
