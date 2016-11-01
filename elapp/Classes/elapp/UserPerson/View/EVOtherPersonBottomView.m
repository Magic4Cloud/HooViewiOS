//
//  EVOtherPersonBottomView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVOtherPersonBottomView.h"
#import <PureLayout/PureLayout.h>

CGFloat const bottomViewHeight = 45.0f;

@implementation EVOtherPersonBottomView

#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildOtherPersonVCBottomView];
    }
    return self;
}

#pragma mark - build UI
- (void)buildOtherPersonVCBottomView {
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.followButton];
    [self.bottomView addSubview:self.messageSendButton];
    [self.bottomView addSubview:self.pullBlackButton];
    
    [self.bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    NSArray *views = @[self.followButton, self.messageSendButton,self.pullBlackButton];
    [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [views autoSetViewsDimension:ALDimensionHeight toSize:bottomViewHeight];
        [views autoDistributeViewsAlongAxis:ALAxisHorizontal
                                  alignedTo:ALAttributeHorizontal
                           withFixedSpacing:0
                               insetSpacing:YES
                               matchedSizes:YES];
        [self.followButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }];
}

- (void)buttonClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomButtonType:button:)]) {
        [self.delegate bottomButtonType:button.tag button:button];
    }
}

#pragma mark - helper
/**
 *  帮助设置 bottomView 上的三个按钮
 */
- (void)settingButton:(UIButton *)btn {
    btn.titleLabel.font = CCNormalFont(14);
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(.0f, -5.0f, .0f, 5.0f)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(.0f, 5.0f, .0f, -5.0f)];
}

#pragma mark - lazy load 💤
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#262626" alpha:.95];
    }
    return _bottomView;
}

- (UIButton *)messageSendButton {
    if (!_messageSendButton) {
        _messageSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageSendButton.tag = EVBottomButtonTypeMessage;
        [_messageSendButton setTitle:kE_GlobalZH(@"private_letter") forState:UIControlStateNormal];
        [_messageSendButton setImage:[UIImage imageNamed:@"personal_icon_otherslettericon"] forState:UIControlStateNormal];
        [self settingButton:_messageSendButton];
        [_messageSendButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _messageSendButton;
}
- (UIButton *)pullBlackButton {
    if (!_pullBlackButton) {
        _pullBlackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pullBlackButton.tag = EVBottomButtpnTypePullBack;
        [_pullBlackButton setTitle:@"拉黑" forState:UIControlStateNormal];
        [_pullBlackButton setTitle:@"解除拉黑" forState:UIControlStateSelected];
        [_pullBlackButton setImage:[UIImage imageNamed:@"personal_icon_defriend"] forState:UIControlStateNormal];
        [_pullBlackButton setImage:[UIImage imageNamed:@"personal_icon_defriend"] forState:UIControlStateSelected];
          [_pullBlackButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self settingButton:_pullBlackButton];
    }
    return _pullBlackButton;
}


- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.tag = EVBottomButtonTypeFollow;
        [_followButton setTitle:kNavigatioBarFollow forState:UIControlStateNormal];
        [_followButton setTitle:kE_GlobalZH(@"e_cancel_follow") forState:UIControlStateSelected];
        [_followButton setImage:[UIImage imageNamed:@"personal_icon_add_yellow"] forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"personal_icon_added_yellow"] forState:UIControlStateSelected];
        [self settingButton:_followButton];
        [_followButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _followButton;
}

@end
