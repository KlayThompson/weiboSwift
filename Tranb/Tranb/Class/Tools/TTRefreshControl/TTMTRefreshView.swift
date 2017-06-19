//
//  TTMTRefreshView.swift
//  Tranb
//
//  Created by Kim on 2017/6/19.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TTMTRefreshView: TTRefreshView {

 
    /// 背景建筑图片
    @IBOutlet weak var buildingImageView: UIImageView!
    
    /// 地球图片
    @IBOutlet weak var earthImageView: UIImageView!
    
    /// 袋鼠图片
    @IBOutlet weak var kangarooImageView: UIImageView!
    
    /// 父视图高度
    override var parentViewHeight: CGFloat {
        didSet {
            //小于30袋鼠还没出现
            if parentViewHeight < 30 {
                return
            }
            
            var scale = 1 - ((133 - parentViewHeight) / (133 - 30))
            if scale > 1 {
                scale = 1
            }
            
            kangarooImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //小房子动画
        let image1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let image2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingImageView.image = UIImage.animatedImage(with: [image1,image2], duration: 0.3)
        
        //地球转的动画🌎
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.toValue = -(2 * Double.pi)
        animate.repeatCount = MAXFLOAT
        animate.duration = 3
        animate.isRemovedOnCompletion = false
        
        earthImageView.layer.add(animate, forKey: nil)
        
        //袋鼠
        //设置锚点
        kangarooImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置center
        kangarooImageView.center = CGPoint(x: self.bounds.width*0.5, y: self.bounds.height - 30)
        
        //设置缩放
        kangarooImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        //设置袋鼠动画
        let kangarooImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kangarooImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        
        kangarooImageView.image = UIImage.animatedImage(with: [kangarooImage1,kangarooImage2], duration: 0.3)
        
    }

}
