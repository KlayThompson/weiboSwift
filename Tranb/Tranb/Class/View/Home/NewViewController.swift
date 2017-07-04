//
//  NewViewController.swift
//  Tranb
//
//  Created by Kim on 2017/6/2.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

class NewViewController: BaseViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviItem.rightBarButtonItem = UIBarButtonItem(title: "Next", target: self, action: #selector(NewViewController.nextView))
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func nextView() {
        navigationController?.pushViewController(NewViewController(), animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
