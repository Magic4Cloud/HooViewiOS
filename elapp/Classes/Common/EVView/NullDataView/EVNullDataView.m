//
//  EVNullDataView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNullDataView.h"
#import <PureLayout.h>

#define kBtnHeight 30.f

@interface EVNullDataView ()

@property ( nonatomic, weak ) UIImageView *topImageView;
@property ( weak, nonatomic ) UILabel *titleLabel;
@property ( weak, nonatomic ) UILabel *subtitleLabel;
@property ( weak, nonatomic ) UIButton *button;
@property ( strong, nonatomic ) NSLayoutConstraint *buttonHeightConstraint;


@end

@implementation EVNullDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    // 容器
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView autoCenterInSuperview];
    contentView.backgroundColor = [UIColor clearColor];
    [contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    
    
    // 头像
    UIImageView *topImageView = [[UIImageView alloc] init];
    [contentView addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"personal_empty"];
    [topImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:contentView];
    [topImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [topImageView autoSetDimensionsToSize:topImageView.image.size];
    topImageView.backgroundColor = [UIColor clearColor];
    self.topImageView = topImageView;
    
    // 主标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topImageView withOffset:10.f];
    self.titleLabel = titleLabel;
    titleLabel.font = CCNormalFont(15);
    titleLabel.textColor = [UIColor evTextColorH3];
    
    // 副标题
    UILabel *subtitleLabel = [[UILabel alloc] init];
    [contentView addSubview:subtitleLabel];
    [subtitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:10.f];
    self.subtitleLabel = subtitleLabel;
    subtitleLabel.font = CCNormalFont(12);
    subtitleLabel.textColor = CCTextBlackColor;
    subtitleLabel.hidden = YES;
    
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:button];
    CGFloat width = 100.f;
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:subtitleLabel withOffset:4.f];
    [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.buttonHeightConstraint = [button autoSetDimension:ALDimensionHeight toSize:0.f];
    [button autoSetDimension:ALDimensionWidth toSize:width];
    [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    button.layer.cornerRadius = 3;
    button.backgroundColor = [UIColor evAssistColor];
    self.button = button;
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = CCNormalFont(15);
    button.hidden = YES;
}

- (void)setTopImage:(UIImage *)topImage
{
    _topImage = topImage;
    self.topImageView.image = _topImage;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    if ( _subtitle.length > 0 )
    {
        self.subtitleLabel.text = _subtitle;
        self.subtitleLabel.hidden = NO;
    }
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    if ( _buttonTitle.length > 0 )
    {
        [self.button setTitle:_buttonTitle forState:UIControlStateNormal];
        self.buttonHeightConstraint.constant = 30.f;
        self.button.hidden = NO;
    }
    else
    {
        self.buttonHeightConstraint.constant = 0.f;
    }
}

- (void)addButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

- (void)hideButton:(BOOL)YorN
{
    if (YorN)
    {
        if (self.button.hidden == NO)
        {
            self.button.hidden = YES;
        }
    }
    else
    {
        if (self.button.hidden == YES)
        {
            self.button.hidden = NO;
        }
    }
}

@end
