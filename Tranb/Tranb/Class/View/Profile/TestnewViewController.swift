//
//  TestnewViewController.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/16.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class TestnewViewController: UIViewController {

    
    @IBOutlet weak var tipLabel: UILabel!
    
    
    @IBOutlet weak var removeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tipLabel.text = "缓存为：\(TTCacheManager.share.calculatorCacheSize())"
        
    }

    
    
    @IBAction func removeCachePress(_ sender: UIButton) {
        TTCacheManager.share.removeCacheFile()
        
    }

    

}
