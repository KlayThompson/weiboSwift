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
    
    
    /// access_token 除登录外接口全部需要
    var accessToken: String? = "2.00S2cDxCc2XFVCb8e23fc98e0hJlTN"
    
    /// 用户id
    var userId: String? = "2704931864"
    
    
    /// 包含token的网络请求直接调用此方法
    func requestNetWorkWithToken(requestMethod: RequestMethod = .GET, url: String, params: [String: AnyObject]?, completion: @escaping (_ resultJson: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        //先判断token是否存在，不存在直接返回
        if accessToken == nil {
            print("Token为空，请登录")
            // FIXME: 提示用户登录
            completion(nil, false)
            return
        }
        
        //判断参数params是否为空，为空则创建字典
        var params = params
        
        if params == nil {
            params = [String: AnyObject]()
        }
        params?["access_token"] = accessToken as AnyObject
        
        //调用封装的AF方法
        requestNetWork(url: url, params: params, completion: completion)
    }
    
    
    
    /// 封装的post 和 get 网络请求
    ///
    /// - Parameters:
    ///   - requestMethod: post或者get
    ///   - url: url字符串
    ///   - params: 请求参数
    ///   - completion: 完成回调json数据和isSuccess是否成功
    func requestNetWork(requestMethod: RequestMethod = .GET, url: String, params: [String: AnyObject]?, completion: @escaping (_ resultJson: AnyObject?, _ isSuccess: Bool) -> ()) {
     
        //创建闭包
        let success = { (dataTask: URLSessionDataTask, json: Any?) -> () in
            completion(json as AnyObject, true)
        }
        
        let failure = { (dataTask: URLSessionDataTask?, error: Error) -> () in
            completion(nil, false)
            
            //如果token失效，403，则提示用户重新登录
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                // FIXME: 提示用户登录
                print("Token失效。提示用户重新登录")
            }
            
            print("网络请求错误-----\(error)")
        }

        if requestMethod == .GET {
            get(url, parameters: params, progress: nil, success: success, failure: failure)
        } else {
            post(url, parameters: params, progress:nil, success: success, failure: failure)
        }
        
    }
    
}
