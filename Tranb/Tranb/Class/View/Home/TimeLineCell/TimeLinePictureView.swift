//
//  TimeLinePictureView.swift
//  Tranb
//
//  Created by Kim on 2017/6/13.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TimeLinePictureView: UIView {

    
    /// view高度约束
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    private var urls: [TimeLinePictureUnit]? {
    
        didSet {
            //先隐藏所有的image
            for v in subviews {
                v.isHidden = true
            }
            
            //设置图片
            var index = 0
            //取出url
            for unit in urls ?? [] {
                //取出图片
                let imageView = subviews[index] as! UIImageView
                
                //如果是四张图片特殊处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                imageView.setImage(urlString:  unit.thumbnail_pic, placeholderImage: nil)
                
                imageView.isHidden = false
                
                index += 1
            }
        }
    }
    
    var viewModel: SingleTimeLineViewModel? {
        didSet {
            caculatePictureSize()
            urls = viewModel?.picUrls
        }
    }
    
    /// 计算微博配图尺寸大小
    func caculatePictureSize() {
        
        //要区分是否为一张图片
        if viewModel?.picUrls.count == 1 {
            
            let v = subviews[0]
            let size = viewModel?.pictureSize ?? CGSize()
            
            v.frame = CGRect(x: 0, y: OutMargin, width: size.width, height: size.height - OutMargin)
            
        } else {
            let v = subviews[0]
            
            v.frame = CGRect(x: 0, y: OutMargin, width: PicWidth, height: PicWidth)
        }
        heightCons.constant = viewModel?.pictureSize.height ?? 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func tapImageView(tap: UITapGestureRecognizer) {
        guard let imageView = tap.view as? UIImageView,
            let picUrls = viewModel?.picUrls else {
            return
        }
        /// @param selectedIndex    选中照片索引
        /// @param urls             浏览照片 URL 字符串数组
        /// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
        
        var selectedIndex = imageView.tag
        
        //对四张图片特殊处理
        if selectedIndex > 1 && picUrls.count == 4 {
            selectedIndex -= 1
        }
        
        let urls = (picUrls as NSArray).value(forKey: "thumbnail_pic") as! [String]
        
        var imageViewList = [UIImageView]()
        
        //遍历所有视图
        for view in subviews as![UIImageView] {
            //判断显示的才加入
            if !view.isHidden {
                imageViewList.append(view)
            }
        }
        
// MARK: - 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification),
                                        object: nil,
                                        userInfo: [WBStatusCellBrowserPhotoSelectedIndexKey : selectedIndex, WBStatusCellBrowserPhotoURLsKey : urls, WBStatusCellBrowserPhotoImageViewsKey : imageViewList])
    }
    
}

// MARK: - 设置界面
extension TimeLinePictureView {

    func setupUI() {
        clipsToBounds = true
        backgroundColor = superview?.backgroundColor
        //创建ImageView
        
        let count = 3
        
        let rect = CGRect(x: 0, y: OutMargin, width: PicWidth, height: PicWidth)
        
        
        for index in 0..<count * count {
            
            //创建
            let imageView = UIImageView()
            
            imageView.backgroundColor = UIColor.cyan
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            //计算行、列
            //行 -> Y
            let row = CGFloat(index / count)
            //列-> X
            let col = CGFloat(index % count)
            //计算偏移
            let xOffset = col * (InMargin + PicWidth)
            let yOffset = row * (InMargin + PicWidth)
            
            imageView.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            imageView.isUserInteractionEnabled = true
            
            //添加点击手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            
            imageView.addGestureRecognizer(tap)
            
            imageView.tag = index
            
            addSubview(imageView)
        }
        
    }
    
}
