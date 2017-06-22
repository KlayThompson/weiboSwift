//
//  SingleTimeLineViewModel.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/12.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/// 单个微博视图模型
class SingleTimeLineViewModel: CustomStringConvertible {
    
    var timeLineModel: TimeLineModel
    
    /// 会员图标
    var memberImage: UIImage?
    
    //头像右下角标识icon  认证类型：-1 没有认证，0认证用户，2，3，5企业认证， 220达人
    var avatarIdentifyImage: UIImage?
    
    /// 转发
    var retweetStr: String?
    
    /// 评论
    var commentStr: String?
    
    /// 点赞
    var likeStr: String?
    
    /// 微博配图尺寸
    var pictureSize = CGSize()
    
    /// 若果转发微博有配图就返回转发微博配图，没有就返回原创
    var picUrls: [TimeLinePictureUnit] {
        return timeLineModel.retweeted_status?.pic_urls ?? (timeLineModel.pic_urls ?? [])
    }
    
    /// 被转发微博文字
    var reTweetText: String?
    
    /// 计算的行高
    var rowHeight: CGFloat = 0
    
    /// 微博来源
    var sourceString: String?
    
    
    /// 返回单个微博的视图模型
    ///
    /// - Parameter model: TimeLineModel
    init(model: TimeLineModel) {
        self.timeLineModel = model
        
        guard let user = model.user else {
            return
        }
        
        //common_icon_membership_level1  0-6  会员图标
        if user.mbrank > 0 && user.mbrank < 7 {
            let imageString = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberImage = UIImage(named: imageString)
        }
        
        //认证图标
        switch user.verified_type {
        case 0:
            avatarIdentifyImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            avatarIdentifyImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            avatarIdentifyImage = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //底部toolbar
        retweetStr = countString(count: model.reposts_count, defaultString: "转发")
        commentStr = countString(count: model.comments_count, defaultString: "评论")
        likeStr = countString(count: model.attitudes_count, defaultString: "赞")
        
        //微博配图尺寸计算
        pictureSize = calulatorPictureSize(imageCount: picUrls.count)
        
        //被转发微博文字
        reTweetText = "@" + (model.retweeted_status?.user?.screen_name ?? "") + "：" + (model.retweeted_status?.text ?? "")
        
        for unit in picUrls {
        
            guard var urlString = unit.thumbnail_pic else {
                return
            }
            
            //显示大图
            if urlString.contains("thumbnail") {
                urlString = urlString.replacingOccurrences(of: "thumbnail", with: "large")
            }
            unit.thumbnail_pic = urlString
        }
        
        //计算行高
        calculateRowHeight()
        
        //微博来源
        
    }
    
    //计算行高
    func calculateRowHeight() {
        //原创微博高度：顶部分割视图(12) + 间距12 + 头像的高度34 + 间距12 + 正文高度(计算) + 配图视图高度(计算) + 间距12 + 底部视图高度35
        //转发微博高度：顶部分割视图(12) + 间距12 + 头像的高度34 + 间距12 + 正文高度(计算) + 间距12 + 间距12 + 转发文本高度(计算) + 配图视图高度(计算) + 间距12 + 底部视图高度35
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        //定义高度
        var height: CGFloat = 0
        //顶部位置
        height += 2 * margin + iconHeight + margin
        
        let textSize = CGSize(width: SCREEN_WIDTH - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalTextAttri = UIFont.systemFont(ofSize: 15)
        let retweetTextAttri = UIFont.systemFont(ofSize: 14)
        //正文高度
        if let text = timeLineModel.text {
            
            height += (text as NSString).boundingRect(with: textSize,
                                                      options: [.usesLineFragmentOrigin],
                                                      attributes: [NSFontAttributeName : originalTextAttri],
                                                      context: nil).height
        }
        
        //是否有转发微博
        if timeLineModel.retweeted_status != nil {
            height += 2 * margin
            
            if let text = reTweetText {
                height += (text as NSString).boundingRect(with: textSize,
                                                          options: [.usesLineFragmentOrigin],
                                                          attributes: [NSFontAttributeName : retweetTextAttri],
                                                          context: nil).height
            }
        }
        
        //配图视图
        height += pictureSize.height
        
        //间距和底部视图
        height += margin
        height += toolbarHeight
        
        //使用属性记录
        rowHeight = height - 1.5
    }
    
    /// 更新单张图片显示尺寸
    ///
    /// - Parameter image: 下载的image
    func updateSingleImageSize(image: UIImage) {
        
        var size = image.size
        
        //图像过大处理
        let maxWidth: CGFloat = 300
        if size.width > maxWidth {
            size.width = maxWidth
            //等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        //过窄图像处理
        let minWidth: CGFloat = 40
        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        
        //需要加一开始顶部预留的12个间距
        size.height += OutMargin
        
        //重新设置配图视图大小，需要重新计算行高
        pictureSize = size
        //更新行高
        calculateRowHeight()
    }
    
    /// 计算微博配图视图整体的尺寸
    ///
    /// - Parameter imageCount: 微博配图的数量
    /// - Returns: return 微博配图视图整体的尺寸
    func calulatorPictureSize(imageCount: Int?) -> CGSize {
        
        //如果不存在count或者count为0则返回空
        if imageCount == 0 || imageCount == nil {
            return CGSize()
        }
    
        //计算高度
        //行数
        let row = (imageCount! - 1)/3 + 1
        
        //根据行数计算高度
        let height = OutMargin + CGFloat(row)*PicWidth + CGFloat(row - 1)*InMargin
        
        return CGSize(width: ViewWidth, height: height)
    }
    
    /// 根据count数目返回toolbar底部显示数字或者文字
    ///
    /// - Parameters:
    ///   - count: 数量
    ///   - defaultString: 默认文字：转发、评论、赞
    /// - Returns: 显示出的文字
    func countString(count: Int, defaultString: String) -> String {
        
        if count == 0 {
            return defaultString
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%0.02f 万", Double(count)/10000)
    }
    
    var description: String {
        return timeLineModel.description
    }
    
}
