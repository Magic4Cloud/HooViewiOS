//
//  EVConnectingErrorView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVConnectingErrorView : UIView

//@property (nonatomic, assign) BOOL living;

@property (nonatomic,strong) UIImage *defaultAnimationImage;

/**
 *  初始化方法
 *
 *  @return
 */
+ (instancetype)connectingErrorView;

/**
 *  停止动画
 */
- (void)stopAnimation;

/**
 *  开始动画
 *
 *  @param title 提示信息
 *  @param image 被模糊化的图片
 */
- (void)startAnimationWithTitle:(NSString *)title;

/** 缓冲百分比 */
@property (nonatomic, assign) int percent;

@end
