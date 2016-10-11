//
//  EVAudienceChatTextView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVChatTextView.h"
#import "EVWatchBottomItemView.h"
@class EVAudienceChatTextView;

#define CCAudienceChatTextViewHeight 31
#define CCAudienceChatTextViewMostH 100

@protocol CCAudienceChatTextViewDelegate <NSObject>

@optional
- (void)audienceChatTextViewDidClickSendButton:(EVAudienceChatTextView *)textView;
- (void)audienceChatTextKeyBarodDidChange:(EVAudienceChatTextView *)textView textFrame:(CGRect)frame animationTime:(NSTimeInterval)time;
- (void)audienceChatTextChangeInputStyle;

@end

@interface EVAudienceChatTextView : UIView

@property (nonatomic, weak) EVChatTextView *textView;

@property (nonatomic,weak) NSLayoutConstraint *heightContraint;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,weak) id<CCAudienceChatTextViewDelegate> delegate;

@property (nonatomic,weak) EVWatchBottomItemView * bottomView;

- (void)setReplyString:(NSString *)reply;

- (void)beginEdit;

/**
 *  @author shizhiang, 15-11-27 11:11:55
 *
 *  清空内容
 */
- (void)emptyText;

@end
