//
//  UIImageView+WebImage.swift
//  Tranb
//
//  Created by Kim on 2017/6/13.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import SDWebImage

extension UIImageView {

    /// 隔离设置加载网络图片
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: placeholderImage
    ///   - isAvatar: 是否是头像
    func setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        //URL
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                
                //设置默认图像
                image = placeholderImage
                return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _) in
            //如果是头像，进行剪裁呈圆形
            if isAvatar {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size, backColor: UIColor.white, lineColor: UIColor.lightGray)
            }
        }
    }
}
