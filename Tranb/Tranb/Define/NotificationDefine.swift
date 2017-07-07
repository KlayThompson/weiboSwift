//
//  NotificationDefine.swift
//  Tranb
//
//  Created by Kim on 2017/6/8.
//  Copyright © 2017年 KlayThompson. All rights reserved.
//

import Foundation

/// 用户需要登录通知
let USER_SHOULD_LOGIN = "UserShouldLogin"

/// 用户登录成功通知
let USER_LOGIN_SUCCESS = "UserLoginSuccess"
		
// MARK: - 照片浏览通知定义
/// @param selectedIndex    选中照片索引
/// @param urls             浏览照片 URL 字符串数组
/// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
/// 微博 Cell 浏览照片通知
let WBStatusCellBrowserPhotoNotification = "WBStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let WBStatusCellBrowserPhotoSelectedIndexKey = "WBStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let WBStatusCellBrowserPhotoURLsKey = "WBStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let WBStatusCellBrowserPhotoImageViewsKey = "WBStatusCellBrowserPhotoImageViewsKey"
