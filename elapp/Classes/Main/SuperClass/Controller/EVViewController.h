//
//  EVViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Extension.h"

@interface EVViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *coverView;

@property ( strong, nonatomic ) UIBarButtonItem *cc_leftBarButtonItem;

/**
 *  @author shizhiang, 16-01-11 15:01:01
 *
 *  添加手势引导
 *
 *  @param imageNamed 手势引导的图片
 */
- (void)addGestureGuideCoverviewWithImageNamed:(NSString *)imageNamed;

/**
 *  @author shizhiang, 16-01-11 19:01:33
 *
 *  移除手势引导
 */
- (void)hideCoverImageView;


/**
 *  @author shizhiang, 16-01-08 17:01:20
 *
 *  返回上一级
 */
- (void)popBack;

@end
