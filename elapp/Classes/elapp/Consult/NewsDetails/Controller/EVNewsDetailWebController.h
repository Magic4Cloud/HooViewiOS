//
//  EVNewsDetailWebController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"

@interface EVNewsDetailWebController : EVViewController

@property (nonatomic, copy) NSString *newsID;

@property (nonatomic, copy) NSString *newsTitle;

@property (nonatomic, copy) NSString *announcementTitle;
@property (nonatomic, copy) NSString *announcementURL;

/**
 刷新评论数
 */
@property (nonatomic, copy)void(^refreshViewCountBlock)();

/**
 刷新收藏列表
 */
@property (nonatomic, copy)void(^refreshCollectBlock)();
@end
