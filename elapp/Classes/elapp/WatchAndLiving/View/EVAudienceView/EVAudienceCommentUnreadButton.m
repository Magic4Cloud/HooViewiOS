//
//  EVAudienceCommentUnreadButton.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudienceCommentUnreadButton.h"
#import <PureLayout.h>

@interface EVAudienceCommentUnreadButton ()

// 显示"xx条未读消息"
@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation EVAudienceCommentUnreadButton

#pragma mark - initialize
+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    EVAudienceCommentUnreadButton *btn = [super buttonWithType:buttonType];
    [btn setUI];
    return btn;
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

- (void)setUnreadNum:(NSInteger)unreadNum
{
    _unreadNum = unreadNum;
    self.textLabel.text = [NSString stringWithFormat:@"%zd%@", unreadNum,kE_GlobalZH(@"num_new_message")];
}

- (UILabel *)titleLabel
{
    return self.textLabel;
}

- (void)setUI
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor evTextColorH1];
    textLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:textLabel];
    [textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [textLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    _textLabel = textLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    UIImage * arrowImage = [UIImage imageNamed:@"message_more"];
    arrowImage = [arrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrowImageView.image = arrowImage;
    arrowImageView.tintColor = [UIColor colorWithHexString:@"#403B37"];
    [self addSubview:arrowImageView];
    [arrowImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:textLabel withOffset:2];
    [arrowImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

@end
