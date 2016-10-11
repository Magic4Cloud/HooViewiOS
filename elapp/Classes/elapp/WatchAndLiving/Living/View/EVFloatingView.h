//
//  EVFloatingView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CCFloatingViewCancel = 1000,  // 取消按钮
    CCFloatingViewReport,         // 举报按钮
    CCFloatingViewShutup,         // 禁言按钮
    CCFloatingViewHomePage,       // 主页按钮
    CCFloatingViewMessage,        // 私信按钮
    CCFloatingViewAtTa,           // @ta按钮
    CCFloatingViewFocucs          // 加关注按钮
} CCFloatingViewButtonTag;

@class EVFloatingView;
@class EVUserModel;

@protocol CCFloatingViewDelegate <NSObject>

@optional

- (void)floatingView:(EVFloatingView *)floatingView clickButton:(UIButton *)button;

@end

@interface EVFloatingView : UIView

@property ( weak, nonatomic ) id<CCFloatingViewDelegate> delegate;

@property (nonatomic,strong) EVUserModel *userModel;

@property ( weak, nonatomic ) NSLayoutConstraint *floatingViewY;

@property (assign, nonatomic) BOOL isAnchor;  // 判断当前是主播还是看别人播

@property (assign, nonatomic) BOOL isMng;

- (void)show;
- (void)dismiss;

@end
