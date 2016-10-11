//
//  EVVerticalLayoutButton.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVVerticalLayoutButton.h"
#import <PureLayout.h>

@interface EVVerticalLayoutButton ()

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, weak) UIImageView *normalImageView;
@property (nonatomic, weak) UIImageView *selectImageView;
@property (nonatomic, weak) UILabel *myLabel;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *selectBgColor;


@end

@implementation EVVerticalLayoutButton

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpSubviews];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    EVVerticalLayoutButton *btn = [super buttonWithType:buttonType];
    [btn setUpSubviews];
    return btn;
}

- (void)setUpSubviews
{
    UIImageView *normalImageView = [[UIImageView alloc] init];
    [self addSubview:normalImageView];
    _normalImageView = normalImageView;
    [normalImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [normalImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [normalImageView autoSetDimensionsToSize:CGSizeMake(ScreenWidth/375*48, ScreenWidth/375*48)];
    
    UIImageView *selectImageView = [[UIImageView alloc] init];
    [self addSubview:selectImageView];
    [selectImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [selectImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [selectImageView autoSetDimensionsToSize:CGSizeMake(ScreenWidth/375*48, ScreenWidth/375*48)];
    selectImageView.hidden = YES;
    _selectImageView = selectImageView;
    
    UILabel *myLabel = [[UILabel alloc] init];
    [self addSubview:myLabel];
    _myLabel = myLabel;
    myLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:12];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = [UIColor evTextColorH3];
    [myLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:normalImageView withOffset:ScreenWidth/375*8];
    [myLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [myLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.myLabel.font = self.titleLabel.font;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal)
    {
        self.normalImageView.image = image;
    }
    else if (state == UIControlStateSelected)
    {
        self.selectImageView.image = image;
    }
    else
    {
        CCLog(@"没有对这个状态进行处理");
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.selectImageView.hidden = NO;
        self.normalImageView.hidden = YES;
        self.backgroundColor = self.selectBgColor;
        self.myLabel.textColor = CCAppMainColor;
    }
    else
    {
        self.selectImageView.hidden = YES;
        self.normalImageView.hidden = NO;
        self.backgroundColor = self.normalBgColor;
        self.myLabel.textColor = CCTextBlackColor;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    self.myLabel.text = title;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state
{
    if (state == UIControlStateNormal)
    {
        self.normalBgColor = backgroundColor;
        self.backgroundColor = backgroundColor;
    }
    else if (state == UIControlStateSelected)
    {
        self.selectBgColor = backgroundColor;
    }
}

@end
