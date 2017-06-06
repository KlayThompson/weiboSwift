//
//  NetWorkManager.swift
//  Tranb
//
//  Created by Kim on 2017/6/6.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import AFNetworking//直接导入文件夹名称

class NetWorkManager: AFHTTPSessionManager {

    
    //创建单利
    static let shareManager = NetWorkManager()
}
