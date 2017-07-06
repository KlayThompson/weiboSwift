//
//  TTSQLiteManager.swift
//  Tranb
//
//  Created by Kim on 2017/7/5.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation
import FMDB
/**
 1. 数据库本质上是保存在沙盒中的一个文件，首先需要创建并且打开数据库
 FMDB - 队列
 2. 创建数据表
 3. 增删改查
 
 提示：数据库开发，程序代码几乎都是一致的，区别在 SQL
 
 开发*/

/// 最大数据缓存时间
private let maxDBCAtchTime: TimeInterval = -5 * 24 * 60 * 60

/// FMDB数据库管理类
class TTSQLiteManager {

    static let shared = TTSQLiteManager()
    
    /// 数据库队列
    let queue: FMDatabaseQueue
    
    
    /// 构造函数
    private init() {
        
        /// 数据库全路径，拼接一下
        let name = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(name)
        
        print(path)
        
        //创建数据库队列，同时创建或者打开数据库
        queue = FMDatabaseQueue(path: path)
        
        
// MARK: - 打开数据库
        creatTable()
        
        //监听程序进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(clearDBCatch), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    /// 清理数据缓存
    /// 注意细节：
    /// - SQLite 的数据不断的增加数据，数据库文件的大小，会不断的增加
    /// - 但是：如果删除了数据，数据库的大小，不会变小！
    /// - 如果要变小
    /// 1> 将数据库文件复制一个新的副本，status.db.old
    /// 2> 新建一个空的数据库文件
    /// 3> 自己编写 SQL，从 old 中将所有的数据读出，写入新的数据库！
    @objc func clearDBCatch() {
        let dateString = Date.tt_dateString(delta: maxDBCAtchTime)
        //准备SQL
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        
        //执行SQL
        queue.inDatabase { (database) in
            if database?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
                //删除成功
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 微博数据操作
extension TTSQLiteManager {
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    /// - Returns: 微博的字典数组，将数据库中的status二进制数据序列化成为数组字典
    func loadStatus(userId: String, since_id: Int64 = 0,max_id: Int64 = 0) -> [[String : AnyObject]] {
        
        //1.准备SQL
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        // 上拉／下拉，都是针对同一个 id 进行判断
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        // 拼接 SQL 结束后，一定一定一定要测试！
        print(sql)
        
        
        //2.执行SQL
        let array = execRecordSet(sql: sql)
        
        //结果数组
        var result = [[String : AnyObject]]()
        
        //遍历数组，取出data。进行反序列化
        for dic in array {
            guard let data = dic["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else {
                continue
            }
            result.append(json ?? [:])
        }
        
        return result
    }

    /// 新增或者修改微博数据，微博数据再刷新的时候可能会出现重叠
    ///
    /// - Parameters:
    ///   - userid: 当前用户id
    ///   - timelineArray: 微博数据数组
    func updateTimeLine(userid: String, timelineArray: [[String : AnyObject]]) {
        //1.准备SQL
        /**
         statusId:  要保存的微博代号
         userId:    当前登录用户的 id
         status:    完整微博字典的 json 二进制数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"

        //2.执行SQL
        queue.inTransaction { (database, rollback) in
            
            //遍历数组，逐条插入微博数据
            for dic in timelineArray {
                //获取statusId
                guard let statusId = dic["idstr"] as? String,
                    //将字典序列化成二进制数据
                    let status = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
                    continue
                }
                
                //执行sql
                if database?.executeUpdate(sql, withArgumentsIn: [statusId, userid, status]) == false {
                    //执行失败需要回滚
                    rollback?.pointee = true
                    break
                }
                
            }
            
        }
    }
}



// MARK: - 打开数据库
extension TTSQLiteManager {

    /// 执行查询一个SQL，返回字典数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典数组
    func execRecordSet(sql: String) -> [[String : AnyObject]] {
        //执行sql。查询数据不会修改数据，所以不需要开启事物
        //事物的目的，是为了保证数据的有效性，一旦失效回到初始状态
        //结果数组
        var result = [[String : AnyObject]]()
        queue.inDatabase { (database) in
            guard let rs = database?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            //逐行遍历结果集合
            while rs.next() {
                //1.列数
                let colCount = rs.columnCount()
                
                //2.遍历所有列
                for col in 0..<colCount {
                    //3.列名--key
                    guard let name = rs.columnName(for: col),
                    //4.值--value
                        let value = rs.object(forColumnIndex: col) else {
                        continue
                    }
                    
                    result.append([name : value as AnyObject])
                }
            }
        }
        
        
        return result
    }
    
    /// 打开数据库
    func creatTable() {
        //1.SQL
        guard let path = Bundle.main.path(forResource: "Status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path) else {
            return
        }
        
        print(sql)
        
        
        //2.执行SQL -- FMDB内部队列，串行队列，同步执行
        //  可以保证同一时刻只有一个任务操作数据库，从而保证数据库读写安全
        //只有在创表的时候使用执行多条语句，可以一次创建多个表数据
        //在执行增删改查的时候不要使用该语句，可能会导致会被注入
        queue.inDatabase { (database) in
            if database?.executeStatements(sql) == true {
                print("创表失败")
            } else {
                print("创表成功")
            }
        }
        
        print("完成操作")
    }
}

