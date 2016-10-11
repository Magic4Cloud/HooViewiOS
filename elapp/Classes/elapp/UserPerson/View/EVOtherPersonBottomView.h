//
//  EVOtherPersonBottomView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const bottomViewHeight;
typedef NS_ENUM(NSInteger, EVBottomButtonType)
{
    EVBottomButtonTypeMessage,
    EVBottomButtonTypeFollow,
    EVBottomButtpnTypePullBack,
};

@protocol EVButtonDelegete <NSObject>


- (void)bottomButtonType:(EVBottomButtonType)buttonType button:(UIButton *)button;

@end

@interface EVOtherPersonBottomView : UIView

@property (nonatomic, strong) UIView   *bottomView;
@property (nonatomic, strong) UIButton *messageSendButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *pullBlackButton;

@property (nonatomic ,weak) id <EVButtonDelegete> delegate;
@end
