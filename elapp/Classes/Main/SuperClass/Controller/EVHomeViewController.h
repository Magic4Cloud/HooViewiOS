//
//  EVHomeViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface EVHomeViewController : UITabBarController



@property ( strong, nonatomic ) NSMutableArray *allMessages; // 所有离线消息(给招呼页使用)

/**
 判断是否显示小红点的状态
 */
@property (nonatomic, assign)BOOL isShowingBadgeRedPoint;

@property (nonatomic, copy)void(^homeTabbarDidClickedBlock)(NSInteger index);

/**
 *  init method
 *
 *  @param items
 *
 *  @return
 */
+ (instancetype)homeViewControllerWithItems:(NSArray *)items;

/**
 *  与对应的用户开始聊天
 *
 *  @param name  云播号
 */
- (void)startChatWithName:(NSString *)name;



- (void)showHomeTabbarWithAnimation;
- (void)hideHomeTabbarWithAnimation;
- (void)startLive;

- (void)showBadgeRedPoint;
- (void)hideBadgeRedPoint;


@end
