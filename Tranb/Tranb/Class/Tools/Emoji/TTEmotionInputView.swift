//
//  TTEmotionInputView.swift
//  Tranb
//
//  Created by Kim on 2017/6/30.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import UIKit

private let cellID = "CELLID"


class TTEmotionInputView: UIView {

    //底部toolbar
    @IBOutlet weak var toolbar: UIView!
    //基本的collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    class func inputView() -> TTEmotionInputView {
        
        let nib = UINib(nibName: "TTEmotionInputView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! TTEmotionInputView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
//        collectionView.register(UINib(nibName: "TTEmotionCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.register(TTEmotionCell.self, forCellWithReuseIdentifier: cellID)
    }

}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension TTEmotionInputView: UICollectionViewDataSource,UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TTEmojiManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //魅族表情包数量/20
        return TTEmojiManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TTEmotionCell
        cell.emoticons = TTEmojiManager.shared.packages[indexPath.section].emotionWithMax20(page: indexPath.row)
        return cell
    }
}
