//
//  EVCenterPresentView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVStartResourceTool.h"

#define DEFAULT_ANIMTION_TIME 3

@interface EVCenterPresentView : UIView

/**
 *  @author shizhiang, 16-12-29 18:12:47
 *
 *  使用某个礼物执行动画
 *
 *  @param presentid 需要执行动画的礼物
 */
- (void)startAnimationWithPresent:(EVStartGoodModel *)present;

@end
