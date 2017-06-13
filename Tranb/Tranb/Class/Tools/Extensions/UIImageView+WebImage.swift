//
//  UIImageView+WebImage.swift
//  Tranb
//
//  Created by Kim on 2017/6/13.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import SDWebImage

extension UIImageView {

    func setImage(urlString: String?, placeholderImage: UIImage?) {
        
        //URL
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                
                //设置默认图像
                image = placeholderImage
                return
        }
        
        
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, _, _, _) in
            
        }
    }
}
