//
//  EVRiceAmountView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRiceAmountView.h"
#import <PureLayout.h>

@interface EVRiceAmountView ()

/** 显示数量 */
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation EVRiceAmountView

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

- (void)setRiceAmount:(unsigned long long)riceAmount
{
    _riceAmount = riceAmount;
    self.numLabel.text = [NSString stringWithFormat:@"%lld", (unsigned long long)riceAmount];
    if ( !IOS8_OR_LATER )
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)riceAmountTap
{
  
        if (self.delegate && [self.delegate respondsToSelector:@selector(riceAmoutViewDidSelect)])
        {
            // adapt delete by 佳南
//            [self.delegate riceAmoutViewDidSelect];
        }
}

- (void)setUpView
{
    // adapt delete by 佳南
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(riceAmountTap)];
//    [self addGestureRecognizer:tap];
//    
//    UIButton *riceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    riceBtn.userInteractionEnabled = NO;
//    riceBtn.imageEdgeInsets = UIEdgeInsetsMake(-3, -5, 0, 0);
//    [riceBtn setTitle:[NSString stringWithFormat:@"%@ ",kE_GlobalZH(@"e_ticket")] forState:(UIControlStateNormal)];
//    riceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
//    [riceBtn setTitleColor:[UIColor evMainColor] forState:(UIControlStateNormal)];
////    [riceBtn setImage:[UIImage imageNamed:@"living_icon_rice"] forState:UIControlStateNormal];
//    [self addSubview:riceBtn];
//    [riceBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    [riceBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//    UILabel *numLabel = [[UILabel alloc] init];
//    numLabel.textColor = [UIColor whiteColor];
//    numLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:15.0];
//    [self addSubview:numLabel];
//    [numLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:riceBtn withOffset:4];
//    [numLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    _numLabel = numLabel;
//    
//    UIImageView *moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"living_ranking_more"]];
//    [self addSubview:moreImageView];
//    [moreImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [moreImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
//    [moreImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:numLabel withOffset:5];
//    [moreImageView autoSetDimensionsToSize:CGSizeMake(13, 13)];
}

@end
