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
    static let shareManager:NetWorkManager = {
    
        let instance = NetWorkManager()
        
        //设置反序列化
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    
    /// 用户信息模型
    lazy var userInfo = UserInfoModel()
    
    /// 用户登录状态
    var userLogin: Bool {
        return userInfo.access_token != nil
    }
    
    /// 包含token的网络请求直接调用此方法
    func requestNetWorkWithToken(requestMethod: RequestMethod = .GET, url: String, params: [String: AnyObject]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ resultJson: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        //先判断token是否存在，不存在直接返回
        if userInfo.access_token == nil {
            print("Token为空，请登录")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_SHOULD_LOGIN), object: nil)
            completion(nil, false)
            return
        }
        
        //判断参数params是否为空，为空则创建字典
        var params = params
        
        if params == nil {
            params = [String: AnyObject]()
        }
        params?["access_token"] = userInfo.access_token as AnyObject
        
        //调用封装的AF方法
        if let name = name, let data = data {//上传数据
            uploadDataToServer(urlString: url, params: params, name: name, data: data, completion: completion)
        } else {//正常请求数据
            requestNetWork(requestMethod: requestMethod, url: url, params: params, completion: completion)
        }
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
        print("")
        let failure = { (dataTask: URLSessionDataTask?, error: Error) -> () in
            completion(nil, false)
            
            //如果token失效，403，则提示用户重新登录
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                print("Token失效。提示用户重新登录")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_SHOULD_LOGIN), object: "BAD TOKEN")
            }
            
            print("网络请求错误-----\(error)")
        }

        if requestMethod == .GET {
            get(url, parameters: params, progress: nil, success: success, failure: failure)
            guard let params = params else {
                print("接口URL ----:\(url)")
                return
            }
            var paramsString = "?"
            
            for (key,value) in params {
                paramsString = paramsString + "\(key)=\(value)&"
            }
            paramsString.remove(at: paramsString.index(before: paramsString.endIndex))
            paramsString = url + paramsString
            print("接口URL ----:\(paramsString)")
        } else {
            post(url, parameters: params, progress:nil, success: success, failure: failure)
        }
        
    }
    
    /// 上传数据到服务端
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - params: 参数
    ///   - name: 服务器名称
    ///   - data: 数据
    ///   - completion: 完成回调
    func uploadDataToServer(urlString: String, params: [String : AnyObject]?, name: String, data: Data, completion: @escaping (_ resultJson: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        
        post(urlString, parameters: params, constructingBodyWith: { (formData) in
            /**
                data: 要上传的二进制数据
                name: 服务器接受数据的字段名
                fileName: 保存在服务器的文件名，大多数服务漆可以乱写，
                mimeType: 告诉服务器文件类型，不想告诉可以上传application/octet-stream
             */
            formData.appendPart(withFileData: data, name: name, fileName: "caicaikan", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, json) in
            
            completion(json as AnyObject, true)
        }) { (dataTask, error) in
            
            completion(nil, false)
            //如果token失效，403，则提示用户重新登录
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token失效。提示用户重新登录")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_SHOULD_LOGIN), object: "BAD TOKEN")
            }
            print("网络请求错误-----\(error)")
        }
    }
    
}
