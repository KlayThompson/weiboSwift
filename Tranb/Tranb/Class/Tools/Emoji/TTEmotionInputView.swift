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
    
    //选择表情回调
    var selectEmoticonCallBack: ((_ emoticon: TTEmotionModel?)->())?
    
    class func inputView(selectEmoticon: @escaping (_ emoticon: TTEmotionModel?)->()) -> TTEmotionInputView {
        
        let nib = UINib(nibName: "TTEmotionInputView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TTEmotionInputView
        
        v.selectEmoticonCallBack = selectEmoticon
        
        return v
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
        
        //遵循协议
        cell.delegate = self
        
        return cell
    }
}

// MARK: - TTEmotionCellDelegate
extension TTEmotionInputView: TTEmotionCellDelegate {
    /// 选中了表情按钮
    ///
    /// - Parameter emoticon: emoticon为空为删除按钮，不为空就为表情按钮
    func cellDidSelectedEmoticon(cell: TTEmotionCell, emoticon: TTEmotionModel?) {
        selectEmoticonCallBack?(emoticon)
    }
}
