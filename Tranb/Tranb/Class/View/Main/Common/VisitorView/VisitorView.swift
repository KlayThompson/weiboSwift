//
//  VisitorView.swift
//  Tranb
//
//  Created by Kim on 2017/6/2.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 设置界面
extension VisitorView {

    func setupUI() {
        
        backgroundColor = UIColor.white
        
    }
}
