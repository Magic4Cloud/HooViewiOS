//
//  EVHVWatchCenterView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchCenterView.h"
#import "UIButton+Extension.h"
#import "EVLoginInfo.h"

@interface EVHVWatchCenterView ()
@property (nonatomic, weak) UIButton *headImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *subtitleLabel;

@property (nonatomic, weak) UIButton *followButton;

@end


@implementation EVHVWatchCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UIButton  *headImageView = [[UIButton alloc] init];
    [contentView addSubview:headImageView];
    self.headImageView = headImageView;
    headImageView.layer.cornerRadius = 15.f;
    headImageView.layer.masksToBounds = YES;
    headImageView.tag = EVHVWatchCenterTypeHeadImage;
    headImageView.backgroundColor = [UIColor whiteColor];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [headImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [headImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [headImageView addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor evTextColorH1];
    titleLabel.font = [UIFont textFontB2];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:contentView withOffset:4];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:16];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"";
    [contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    subtitleLabel.textColor = [UIColor evTextColorH2];
    subtitleLabel.font = [UIFont systemFontOfSize:12.f];
    [subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:0];
    [subtitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:16];
    [subtitleLabel autoSetDimensionsToSize:CGSizeMake(100, 17)];
    
    
    
    
    UIButton  *followButton = [[UIButton alloc] init];
    [contentView addSubview:followButton];
    followButton.layer.cornerRadius = 4.f;
    followButton.layer.masksToBounds = YES;
    followButton.layer.borderWidth = 1;
    followButton.tag = EVHVWatchCenterTypeFollow;
    followButton.layer.borderColor = [UIColor evLineColor].CGColor;
    [followButton setTitle:@"关注" forState:(UIControlStateNormal)];
    followButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [followButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    followButton.backgroundColor = [UIColor whiteColor];
    [followButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
    [followButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [followButton autoSetDimensionsToSize:CGSizeMake(80, 30)];
    [followButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.followButton = followButton;
    [self.followButton setImage:[UIImage imageNamed:@"btn_unconcerned_n"] forState:(UIControlStateNormal)];
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self.headImageView cc_setImageURL:watchVideoInfo.logourl forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = watchVideoInfo.nickname;
    self.subtitleLabel.text = watchVideoInfo.signature;
    if ([watchVideoInfo.name isEqualToString:[EVLoginInfo localObject].name]) {
        self.followButton.hidden = YES;
    }
}

- (void)setIsFollow:(BOOL)isFollow
{
    _isFollow = isFollow;
    NSString *imageStr = isFollow ? @"btn_concerned_s": @"btn_unconcerned_n";
    [self.followButton setImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
    NSString *titleStr = isFollow ? @"已关注" : @"关注";
    [self.followButton setTitle:titleStr forState:(UIControlStateNormal)];
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchCenterViewType:)]) {
        [self.delegate watchCenterViewType:btn.tag];
    }
}
@end
