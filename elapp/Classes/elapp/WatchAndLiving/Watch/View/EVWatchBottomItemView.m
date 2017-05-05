//
//  EVWatchBottomItemView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVWatchBottomItemView.h"
#import <PureLayout.h>
#define kCCWatchBottomItemViewButtonSpace   10.0f

@implementation EVWatchBottomItemView

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    for (UIView *subView in self.subviews)
    {
        BOOL timeLineHidden = self.timeLineButton.hidden;
        BOOL chatHidden = self.chatButton.hidden;
        subView.hidden = hidden;
        self.timeLineButton.hidden = timeLineHidden;
        self.chatButton.hidden = chatHidden;
    }
}

- (void)hiddenLeftBtn:(BOOL)hidden
{
    _shareButton.hidden = hidden;
    _giftButtton.hidden = hidden;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    // 聊天按钮
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setImage:[UIImage imageNamed:@"living_icon_talk"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    chatBtn.tag = EVWatchBottomItemChat;
    _chatButton = chatBtn;
    [self addSubview:chatBtn];
    [chatBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];

    // 回放
    UIButton *timelineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [timelineBtn setImage:[UIImage imageNamed:@"living_icon_timeline"] forState:UIControlStateNormal];
    [timelineBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _timeLineButton = timelineBtn;
    timelineBtn.tag = EVWatchBottomItemTimeLine;
    [self addSubview:timelineBtn];
    [timelineBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [timelineBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
   self.timeLineConstraint = [timelineBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:chatBtn withOffset:10];
    
    
    
    // 礼物
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setImage:[UIImage imageNamed:@"living_icon_gif_more"] forState:UIControlStateNormal];
    _giftButtton = giftBtn;
    [giftBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.tag = EVWatchBottomItemGif;
    [self addSubview:giftBtn];
    [giftBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    
    // 分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"living_icon_share"] forState:UIControlStateNormal];
    _shareButton = shareBtn;
    [shareBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = EVWatchBottomItemShare;
    [self addSubview:shareBtn];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [shareBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [shareBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:giftBtn withOffset:-kCCWatchBottomItemViewButtonSpace];
    
    
    // 分享按钮
    UIButton *linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [linkBtn setImage:[UIImage imageNamed:@"living_icon_link_anchor"] forState:UIControlStateNormal];
    _linkButton = linkBtn;
    [linkBtn addTarget:self action:@selector(watchBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    linkBtn.tag = EVWatchBottomItemlink;
    [self addSubview:linkBtn];
    [linkBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [linkBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [linkBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shareBtn withOffset:-kCCWatchBottomItemViewButtonSpace];
    
    
    

}

- (void)watchBottomBtnClick:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(watchBottomViewBtnClick:)] )
    {
        [self.delegate watchBottomViewBtnClick:button];
    }
}

/**
 *  >> 为了解决‘聊天按钮隐藏后，无法点击底层播放按钮’的问题
 *
 *  由于本视图中，最左侧是‘聊天按钮（chatButton）’，当处于 VR 录播状态时，需要隐藏，但又要响应 >>‘本视图(self)的底层视图(CCRecordContrlView)中的播放按钮(pauseOrPlayButton)的事件'<< ，所以通过如下方法，在 chatButton.hidden == YES 时，将该区域的点击事件传到底层视图中(CCRecordControlView)
 */
#pragma mark - UIView Category method
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (self.chatButton.hidden == YES) {
        CGRect touchRect = self.chatButton.bounds;
        if (CGRectContainsPoint(touchRect, point)) {
            return nil;
        }
    }
    return hitView;
}







@end
