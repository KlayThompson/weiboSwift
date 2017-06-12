//
//  NewFeatureView.swift
//  Tranb
//
//  Created by Kim on 2017/6/9.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

/// 升级界面
class NewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
  
    class func newFeatureView() -> NewFeatureView {
        
        let nib = UINib.init(nibName: "NewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! NewFeatureView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
//        super.awakeFromNib()
        //如果从自动布局设置的界面，从xib加载，UIScreen.main.bounds默认是600*600
        let count = 4
        let rect = UIScreen.main.bounds
        
        for index in 0..<count {
            
            let imageName = "new_feature_\(index + 1)"
            
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = rect.offsetBy(dx: CGFloat(index) * rect.width, dy: 0)
            scrollView.addSubview(imageView)
        }
        
        //设置scrollView的contentsize
        scrollView.contentSize = CGSize(width: rect.width * CGFloat((count+1)), height: rect.height)
        scrollView.delegate = self
    }

    @IBAction func enterButttonPress(_ sender: UIButton) {
        
        removeFromSuperview()
    }

}

extension NewFeatureView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //计算当前页数
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        
        //如果是最后一页则移除视图
        if page == scrollView.subviews.count {
            print("欢迎回来")
            removeFromSuperview()
        }
        
        //倒数第二页显示进入按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        enterButton.isHidden = true
        
        //联动pageControl
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        pageControl.currentPage = page
        
        //pageControl的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
    
}
