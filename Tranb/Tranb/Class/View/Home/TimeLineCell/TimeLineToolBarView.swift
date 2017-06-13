//
//  TimeLineToolBarView.swift
//  Tranb
//
//  Created by Kim on 2017/6/13.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TimeLineToolBarView: UIView {

    /// 转发按钮
    @IBOutlet weak var retweetButton: UIButton!
    
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    
    /// 点赞按钮
    @IBOutlet weak var likeButton: UIButton!
    
    var viewModel: SingleTimeLineViewModel? {
        didSet {
            
            retweetButton.setTitle(viewModel?.retweetStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    

}
