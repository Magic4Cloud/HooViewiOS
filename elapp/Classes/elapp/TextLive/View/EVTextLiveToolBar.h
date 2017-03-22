//
//  EVTextLiveToolBar.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZInputView,EVTextLiveToolBar;
@protocol EVTextBarDelegate <NSObject>

- (void)sendMessageBtn:(UIButton *)btn textToolBar:(EVTextLiveToolBar *)textToolBar;

@optional
- (void)chatTextViewDidBeginEditing;
@end


@interface EVTextLiveToolBar : UIView

@property (nonatomic, weak) YZInputView *inputTextView;

@property (nonatomic, weak) UIButton *sendButton;

@property (nonatomic, strong) NSLayoutConstraint *inputTextViewHig;

@property (nonatomic, weak) id<EVTextBarDelegate> delegate;

@end
