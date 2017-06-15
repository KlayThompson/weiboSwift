//
//  TTCacheManager.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/16.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

class TTCacheManager {
    
    
    static let share = TTCacheManager()
    
    func calculatorCacheSize() -> Int {
        //缓存
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
            //取出文件夹下所有文件数组
            let fileArray = FileManager.default.subpaths(atPath: cachePath) else {
                return 0
        }
        
        
        
        var size = 0
        
        //计算文件大小
        for file in fileArray {
            
            //把文件名拼接到路径中
            let path = cachePath + "/\(file)"
            //取出文件属性
            guard let floder = try? FileManager.default.attributesOfItem(atPath: path) else {
                return 0
            }
            
            
            //用元祖取出文件属性
            for (a,b) in floder {
                //累加文件大小
                if a == FileAttributeKey.size {
                    size += (b as! Int)
                }
            }
        }
        
        let totalCache = size / 1024 / 1024
        
        print(totalCache)
        
        
        return totalCache
    }
    
    func removeCacheFile() {
        
        //缓存
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
            //取出文件夹下所有文件数组
            let fileArray = FileManager.default.subpaths(atPath: cachePath) else {
                return
        }
        
        //计算文件大小
        for file in fileArray {
            
            let path = cachePath + "/\(file)"
            
            if FileManager.default.fileExists(atPath: path) {
                
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
            
        }
        
    }
}
