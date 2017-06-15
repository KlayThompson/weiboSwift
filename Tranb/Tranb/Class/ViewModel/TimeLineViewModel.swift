//
//  TimeLineViewModel.swift
//  Tranb
//
//  Created by Kim on 2017/6/7.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation
import SDWebImage
/**
    父类的选择：
 -  如果类需要使用KVC或者字典转模型设置对象值，类就需要继承至NSObject
 -  如果类只是包装一些代码逻辑，可以不用任何父类，好处：更加轻量级
 */

private let pullupMaxCount = 3
//2704931864
/// 微博动态首页数据列表视图模型
class TimeLineViewModel {
    
    /// 存放动态数据数组
    lazy var dataList = [SingleTimeLineViewModel]()
    
    /// 上啦刷新没有数据次数
    var pullupNoDataCount = 0
    
    
    /// 请求Timeline数据，由ViewController调用
    ///
    /// - Parameters:
    ///   - isPullUp: 是否是上拉刷新
    ///   - completion: 完成后回调
    func requestTimeLineData(isPullUp: Bool ,completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        //如果上拉刷新没数据次数到达要求则直接返回
        if isPullUp && pullupNoDataCount >= pullupMaxCount {
            print("小伙子，不能在上拉刷新了---换个玩吧")
            return
        }
        
        
        //获取第一个微博since_id
        let since_id = isPullUp ? 0 : (dataList.first?.timeLineModel.id ?? 0)
        //获取最后一个微博的maxID
        let max_id = isPullUp ? (dataList.last?.timeLineModel.id ?? 0) : 0
        
        
        NetWorkManager.shareManager.requestTimeLineListData(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            
            if !isSuccess {
                completion(isSuccess)
                return
            }
            
            var array = [SingleTimeLineViewModel]()
            
            //遍历数组（数组中是字典）
            for dic in json ?? [] {
                
                //创建微博模型
                let model = TimeLineModel()
                
                //设置模型值
                model.yy_modelSet(with: dic)
                
                //使用微博模型 创建微博视图模型
                let viewModel = SingleTimeLineViewModel(model: model)
                
                //添加到数组
                array.append(viewModel)
                
            }
            
            
            
//            //字典转模型
//            guard let array = NSArray.yy_modelArray(with: TimeLineModel.self, json: json ?? []) as? [TimeLineModel] else {
//                
//                completion(isSuccess)
//                return
//            }
            print(json ?? "")
            print(array.count)
            if isPullUp {
                //在数组后面拼接
                self.dataList += array
            } else {
                //重头开始增加数据
                self.dataList = array + self.dataList
            }
            
            //判断沙拉刷新是否没有数据
            if isPullUp && array.count == 0 {
                self.pullupNoDataCount += 1
                completion(isSuccess)
            } else {
                //缓存单张微博图片
                self.cacheSingleImage(dataArray: array, completion: completion)
            }
            
        }
        
    }
    
    /// 缓存微博单张图片
    ///
    /// - Parameter dataArray: 本次下载的模型数组
    func cacheSingleImage(dataArray: [SingleTimeLineViewModel],completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        //GCD调度组
        let group = DispatchGroup()
        var lengh = 0
        
        
        //循环遍历数组，取出单张图片的URL
        for viewModel in dataArray {
            
            //判断是一张图片才进行，否则跳过
            if viewModel.picUrls.count != 1 {
                continue
            }
            
            //获取URL
            guard var urlString = viewModel.picUrls[0].thumbnail_pic else {
                    continue
            }
            //转换为小图片，节省空间
            if urlString.contains("large") {
                urlString = urlString.replacingOccurrences(of: "large", with: "thumbnail")
            }
            let url = URL(string: urlString)
//            print("这是个URL\(url!)")
            
            //入组
            group.enter()
            //使用SDWebImage下载图像
            //downloadImage 是 SDWebImage 的核心用法
            //图片下载完成会自动保存在沙盒中，文件路径是url的MD5
            //如果沙盒中已经存在该图片，后续使用SD通过URL加载图片都会使用本地沙盒图片，不会发起网络请求，回调方法一样会调用
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, data, _, _) in
                print("这个是下载下来的图片\(String(describing: data))")
                lengh += (data?.count)!
                
                if let image = image {
                    
                    //图像缓存成功，更新尺寸
                    viewModel.updateSingleImageSize(image: image)
                }
                
                //出组
                group.leave()
            })
        }
        
        //监听
        group.notify(queue: DispatchQueue.main) { 
            print("图片缓存完成\(lengh/1024)K®")
            //刷新表格
            completion(true)
        }
        
    }
    
}
