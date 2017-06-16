//
//  TestnewViewController.swift
//  Tranb
//
//  Created by KlayThompson on 2017/6/16.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit
import SVProgressHUD
class TestnewViewController: BaseViewController {

    
    @IBOutlet weak var tipLabel: UILabel!
    
    
    @IBOutlet weak var removeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.isHidden = true
        tipLabel.text = "缓存为：\(TTCacheManager.share.calculatorCacheSize())兆"
        
    }

    
    
    @IBAction func removeCachePress(_ sender: UIButton) {
        TTCacheManager.share.removeCacheFile { (isSuccess) in
            if isSuccess {
               SVProgressHUD.showInfo(withStatus: "缓存清除成功")
                self.tipLabel.text = "缓存为0兆"
            }
        }
        
    }

    

}
