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
 *
 *  添加手势引导
 *
 *  @param imageNamed 手势引导的图片
 */
- (void)addGestureGuideCoverviewWithImageNamed:(NSString *)imageNamed;

/**
 *
 *  移除手势引导
 */
- (void)hideCoverImageView;


/**
 *
 *  返回上一级
 */
- (void)popBack;

@end
