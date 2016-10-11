//
//  EVPresentHeaderView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVCornerView.h"
@class CCHeaderImageView;
@class EVPresentHeaderView;

#define InAndOutTime 3/2
#define OutX (-self.frame.size.width)
#define MoveInAnimationId @"movein"
#define MoveOutAnimationId @"moveout"
#define ScaleAnimationId @"scale"

@protocol CCPresentHeaderViewDelegate <NSObject>

- (void)animationDidStop:(CAAnimation *)anim headerView:(EVPresentHeaderView *)headerView;

@end

@interface EVPresentHeaderView : UIView

@property (nonatomic, weak) id<CCPresentHeaderViewDelegate> delegate;

@property (nonatomic, weak)CCHeaderImageView *logoImageView;

@property (nonatomic, weak)UILabel *nickNameLabel;

@property (nonatomic, weak)UILabel *contentLabel;

@property (nonatomic, weak)UIImageView *presentImageView;

@property (nonatomic, weak)UILabel *numLabel;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, weak) EVCornerView * cornerBack;

/** 数字变化重复次数 */
@property (nonatomic, assign) NSInteger numberAniTime;

/** 数字变化已经执行次数 */
@property (nonatomic, assign) NSInteger didTime;

/** 位移动画 */
@property (nonatomic, strong) CABasicAnimation *moveInAnimation;
@property (nonatomic, strong) CABasicAnimation *moveOutAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *scaleAnimation;

@end
