//
//  EVNativeNewsDetailViewController.h
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 原生新闻详情页
 */
@interface EVNativeNewsDetailViewController : UIViewController
@property (nonatomic, copy) NSString * newsID;
@property (nonatomic, copy) NSString * shareTitle;
/**
 刷新评论数
 */
@property (nonatomic, copy)void(^refreshViewCountBlock)();

/**
 刷新收藏列表
 */
@property (nonatomic, copy)void(^refreshCollectBlock)();

@end
