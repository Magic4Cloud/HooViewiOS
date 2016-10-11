//
//  EVChatTextView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFaceTextView.h"
@class EVChatTextView;

@protocol CCChatTextViewDelegate <NSObject>

@optional
- (void)chatTextViewTextDidChange:(EVChatTextView *)textView;
- (void)chatTextViewSendButtonDidClicked:(EVChatTextView *)textView;

@end

@interface EVChatTextView : EVFaceTextView

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,copy) NSString *placeHoder;

@property (nonatomic, assign) BOOL showSendButton;

@property (nonatomic,weak) id<CCChatTextViewDelegate> chatTextViewDelegate;

@property (nonatomic, strong) UIColor *placeHoderTextColor;

@property (nonatomic, assign) BOOL placeHolderHidden;


@end
