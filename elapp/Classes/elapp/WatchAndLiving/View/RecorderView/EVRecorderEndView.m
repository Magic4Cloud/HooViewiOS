//
//  EVRecorderEndView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRecorderEndView.h"
#import <PureLayout.h>

CGFloat const sendMessageAndAddBuddyBtnHeight = 60;

@interface EVRecorderEndView()
@property (weak, nonatomic) UIButton *cancelBtn;       /**< 取消按钮 */
@property (weak, nonatomic) UIButton *playbackBtn;     /**< 回放按钮 */
@property (weak, nonatomic) UIButton *addbuddyBtn;     /**< 加好友 */
@property (weak, nonatomic) UIButton *sendmessagesBtn; /**< 发私信 */

@end

@implementation EVRecorderEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setHiddenFocusBtn:(BOOL)hiddenFocusBtn
{
    _hiddenFocusBtn = hiddenFocusBtn;
    if (hiddenFocusBtn)
    {
        self.addbuddyBtn.hidden = YES;
        self.sendmessagesBtn.frame = CGRectMake(0, self.sendmessagesBtn.frame.origin.y, self.frame.size.width, self.sendmessagesBtn.frame.size.height);
    }
}

- (void)setHiddenSendmessagesBtn:(BOOL)hiddenSendmessagesBtn
{
    self.sendmessagesBtn.hidden = hiddenSendmessagesBtn;
}

- (void)recorderEndViewBtnClick:(UIButton *)button
{
    if (button.tag == CCRecorderEndViewFocusButton)
    {
        CGRect addBuddyBtnFrame = self.addbuddyBtn.frame;
        CGRect sendMessageBtnFrame = self.sendmessagesBtn.frame;
        addBuddyBtnFrame.origin.x = -addBuddyBtnFrame.size.width;
        sendMessageBtnFrame.origin.x = 0;
        sendMessageBtnFrame.size.width = self.bounds.size.width;
        [UIView animateWithDuration:0.5 animations:^{
            self.addbuddyBtn.frame = addBuddyBtnFrame;
            self.sendmessagesBtn.frame = sendMessageBtnFrame;
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(recorderEndView:didClickedButton:)])
    {
        [self.delegate recorderEndView:self didClickedButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.addbuddyBtn.frame = CGRectMake(0, self.frame.size.height - 60 - sendMessageAndAddBuddyBtnHeight, self.frame.size.width / 2, sendMessageAndAddBuddyBtnHeight);
    self.sendmessagesBtn.frame = CGRectMake(self.addbuddyBtn.frame.origin.x + self.addbuddyBtn.frame.size.width, self.addbuddyBtn.frame.origin.y, self.addbuddyBtn.frame.size.width, self.addbuddyBtn.frame.size.height);
}

- (void)setUI
{
    UIView *blurView = [[UIView alloc] init];
    [self addSubview:blurView];
    blurView.backgroundColor = [UIColor evBackgroundColor];
    [blurView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    blurView.userInteractionEnabled = YES;
    
    //加主播好友
    UIButton *addbuddyBtn = [[UIButton alloc] init];
    [addbuddyBtn setImage:[UIImage imageNamed:@"home_liveover_icon_add"] forState:UIControlStateNormal];
    [addbuddyBtn setTitle:kE_GlobalZH(@"add_friend") forState:UIControlStateNormal];
    [blurView addSubview:addbuddyBtn];
    addbuddyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _addbuddyBtn = addbuddyBtn;
    addbuddyBtn.tag =  CCRecorderEndViewFocusButton;
    [addbuddyBtn addTarget:self action:@selector(recorderEndViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendmessagesBtn = [[UIButton alloc] init];
    [sendmessagesBtn setImage:[UIImage imageNamed:@"home_liveset_icon_letter"] forState:UIControlStateNormal];
    [sendmessagesBtn setTitle:kE_GlobalZH(@"private_letter") forState:UIControlStateNormal];
    [blurView addSubview:sendmessagesBtn];
    sendmessagesBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    sendmessagesBtn.tag =  CCRecorderEndViewSendPrivateLetter;
    [sendmessagesBtn addTarget:self action:@selector(recorderEndViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendmessagesBtn = sendmessagesBtn;
    
    UILabel *playbacLabel = [[UILabel alloc] init];
    playbacLabel.text = kE_GlobalZH(@"again_watch_once");
    playbacLabel.textColor = [UIColor colorWithCGColor:[UIColor whiteColor].CGColor];
    [blurView addSubview:playbacLabel];
    playbacLabel.textAlignment = NSTextAlignmentCenter;
    playbacLabel.font = [UIFont systemFontOfSize:16.0f];
    [playbacLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:350];
    [playbacLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [playbacLabel autoSetDimensionsToSize:CGSizeMake(110.0, 70.0)];

    //中间的回放按钮
    UIButton *playbackBtn = [[UIButton alloc] init];
    [playbackBtn setImage:[UIImage imageNamed:@"living_over_replay_nor"] forState:UIControlStateNormal];
    [blurView addSubview:playbackBtn];
    _playbackBtn = playbackBtn;
    [playbackBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:playbacLabel withOffset:20];
    playbackBtn.tag =  CCRecorderEndViewPlaybackButton;
    [playbackBtn addTarget:self action:@selector(recorderEndViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [playbackBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];

    //取消按钮
    UIButton *cancelBnt = [[UIButton alloc] init];
    [cancelBnt setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    cancelBnt.tag =  CCRecorderEndViewCancelButton;
    [cancelBnt addTarget:self action:@selector(recorderEndViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:cancelBnt];
    [cancelBnt autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [cancelBnt autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    _cancelBtn = cancelBnt;
}

@end
