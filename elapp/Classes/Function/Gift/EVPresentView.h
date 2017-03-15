//
//  EVPresentView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVMagicEmojiModel.h"
#import "EVStartResourceTool.h"
#import "EVDanmuModel.h"
@class EVPresentView;
@protocol CCPresentViewDelegate <NSObject>

/**
 *  某个礼物开始动画
 *
 *  @param presentid 开始动画的礼物id
 *  @param time  动画执行的次数
 *  @param mine  是否是自己发的
 */
- (void)animationWithPresent:(EVStartGoodModel *)present time:(NSInteger)time mine:(BOOL)mine nickName:(NSString *)nickName;



@end

@interface EVPresentView : UIView

/** 代理 */
@property (nonatomic, weak) id<CCPresentViewDelegate> delegate;

- (void)performRepeatAnimateWithNumber:(NSInteger)number present:(EVStartGoodModel *)present;

/**
 *  添加新的礼物
 *
 *  @param presents 要添加的礼物
 */
- (void)pushPresents:(NSArray *)presents;

/**
 *   停止礼物连发动画
 */
- (void)stopRepeatAnimation;

@end
