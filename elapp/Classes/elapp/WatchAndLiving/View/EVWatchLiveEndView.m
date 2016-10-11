//
//  EVWatchLiveEndView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#define kAnimatinTime 0.4

#import "EVWatchLiveEndView.h"
#import <PureLayout.h>

#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0

@implementation EVWatchLiveEndData

@end

@interface EVWatchLiveEndView ()

@property (nonatomic,weak) UIButton *focusButton;
@property (nonatomic,weak) UIButton *letterButton;
@property ( weak, nonatomic ) UILabel *focusLabel;
@property ( weak, nonatomic ) UILabel *letterLabel;



@end

@implementation EVWatchLiveEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    UIFont *labelFont = CCNormalFont(18);

    CGFloat marginSide = cc_absolute_x(120);
    CGFloat backButtonHeight = 40.f;
    
    UILabel *tipLb = [[UILabel alloc] init];
    tipLb.text = kE_GlobalZH(@"thank_watch");
    tipLb.textColor = [UIColor whiteColor];
    tipLb.font = [UIFont systemFontOfSize:15];
    [self addSubview:tipLb];
    [tipLb autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tipLb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:15];
    
    // 关注
    UIButton *focusButton = [[UIButton alloc] init];
    focusButton.tag = CCWatchEndViewFocusButton;
    [focusButton setImage:[UIImage imageNamed:@"home_liveover_icon_add"] forState:UIControlStateNormal];
    [self addSubview:focusButton];
    [focusButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.likeCountLine withOffset:75];
    [focusButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide];
    self.focusButton = focusButton;
    UILabel *focusLabel = [[UILabel alloc] init];
    focusLabel.text = kE_GlobalZH(@"add_friend");
    [self addSubview:focusLabel];
    self.focusLabel = focusLabel;
    focusLabel.font = labelFont;
    focusLabel.textColor = [UIColor whiteColor];
    [focusLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:focusButton];
    [focusLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:focusButton withOffset:5.f];
    
    // 私信
    UIButton *letterButton = [[UIButton alloc] init];
    letterButton.tag = CCWatchEndViewSendPrivateLetter;
    [letterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [letterButton setImage:[UIImage imageNamed:@"home_liveset_icon_letter"] forState:UIControlStateNormal];
    [self addSubview:letterButton];
    [letterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginSide];
    [letterButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:focusButton];
    self.letterButton = letterButton;
    
    UILabel *letterLabel = [[UILabel alloc] init];
    self.letterLabel = letterLabel;
    letterLabel.text = kE_GlobalZH(@"private_letter");
    letterLabel.font = focusLabel.font;
    [self addSubview:letterLabel];
    letterLabel.textColor = focusLabel.textColor;
    [letterLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:letterButton];
    [letterLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:letterButton withOffset:5.f];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:backButton];
    backButton.tag = CCWatchEndViewCancelButton;
    [backButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [backButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:39.f];
    [backButton autoSetDimension:ALDimensionHeight toSize:backButtonHeight];
    [backButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:focusLabel withOffset:50];
    [backButton setTitle:kEBack forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 6.f;
    backButton.layer.masksToBounds = YES;
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    backButton.backgroundColor = [UIColor evMainColor];
    

    
    for ( UIButton *btn in self.subviews )
    {
        if ( [btn isKindOfClass:[UIButton class]] )
        {
            [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}



- (void)buttonDidClicked:(UIButton *)sender
{
    if ( [self.delegate respondsToSelector:@selector(watchEndView:didClickedButton:)])
    {
        [self.delegate watchEndView:self didClickedButton:sender.tag];
    }
}

- (void)setWatchEndData:(EVWatchLiveEndData *)watchEndData
{
    _watchEndData = watchEndData;
    
    [self.commentCountLabel animationWithCount:watchEndData.commentCount];
    [self.likeCountLabel animationWithCount:watchEndData.likeCount];
    [self.audienceCountLabel animationWithCount:watchEndData.audienceCount];
    [self.riceCountLabel animationWithCount:watchEndData.riceCount];
    
    if ( watchEndData.followed )
    {
        self.focusLabel.text = kE_GlobalZH(@"already_follow");
    }
    else
    {
        self.focusLabel.text = kE_GlobalZH(@"add_friend");
    }
    BOOL isOneself = watchEndData.isOneself;
    self.focusButton.hidden = isOneself;
    self.focusLabel.hidden = isOneself;
    self.letterButton.hidden = isOneself;
    self.letterLabel.hidden = isOneself;

}

- (void)show
{
    __block CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    self.frame = frame;
    [UIView animateWithDuration:kAnimatinTime animations:^{
        frame.origin.y = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)disMiss{
    __block CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    [UIView animateWithDuration:kAnimatinTime animations:^{
        self.frame = frame;
    }];
}


@end
