//
//  EVLiveShareView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVEnums.h"

UIKIT_EXTERN CGFloat const EVShareViewHeight;
@protocol CCLiveShareViewDelegate <NSObject>

@optional
- (void)liveShareViewDidClickButton:(EVLiveShareButtonType)type;
- (void)liveShareViewWillHided;

@end



@interface EVLiveShareView : UIView

- (instancetype)initWithParentView:(UIView *)parentView;
- (void)show;
- (void)dissmiss;
@property (nonatomic, weak) id <CCLiveShareViewDelegate> delegate;
@end
