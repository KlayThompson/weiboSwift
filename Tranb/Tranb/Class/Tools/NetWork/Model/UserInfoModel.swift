//
//  UserInfoModel.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/8.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

private let userInfoFileName: NSString = "userInfo.json"

/// 用户信息模型
class UserInfoModel: NSObject {

    /// 用户ID
    var uid: String?
    
    /// 用户授权的唯一票据，用于调用微博的开放接口
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数。 Double类型属性给个初始值
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 将TimeInterval转换为Date
    var expiresDate: Date?
    
    /// 用户高清头像
    var avatar_hd: String?
    
    /// 用户名
    var screen_name: String?
    
    override init() {
        super.init()
        
        //从路径中取出，字典
        guard let filePath = userInfoFileName.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: filePath),
        let dic = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : AnyObject] else {
                return
        }
       
        //将字典给模型赋值
        self.yy_modelSet(with: dic ?? [:])
        
        //测试数据
        //expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        
        //判断Token是否过期
        if expiresDate?.compare(Date()) != .orderedDescending {
            //账户过期
            print("账户过期")
            access_token = nil
            uid = nil
            
            //删除文件
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    
    override var description: String {
    
        return yy_modelDescription()
    }
    
    
    //保存用户模型
    func saveUserInfoToLocalFile() {
        
        //转换为字典
        var dic = self.yy_modelToJSONObject() as? [String : AnyObject] ?? [:]
        
        //移除expires_in字段
        dic.removeValue(forKey: "expires_in")
        
        //字典序列化data
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted),
            let filePath = userInfoFileName.cz_appendDocumentDir() else {
                print("filePath 或者 data 为空，请检查")
                return
        }
        
        //写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户信息写入成功，地址为：\(filePath)")
    }
}
