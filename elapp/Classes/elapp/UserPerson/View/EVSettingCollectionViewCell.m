//
//  EVSettingCollectionViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSettingCollectionViewCell.h"
#import <ALView+PureLayout.h>

@implementation EVSettingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.upImage = [[UIImageView alloc] init];
    [self addSubview:self.upImage];
    [self.upImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.upImage autoSetDimensionsToSize:CGSizeMake(24, 24)];
    [self.upImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
    
    self.downLabel = [[UILabel alloc] init];
    self.downLabel.textAlignment = NSTextAlignmentCenter;
    self.downLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    self.downLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.downLabel];
    [self.downLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.downLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.upImage withOffset:12];
    
    CALayer * topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    topBorder.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
    [self.layer addSublayer:topBorder];
    
    CALayer * bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5);
    bottomBorder.backgroundColor = topBorder.backgroundColor;
    [self.layer addSublayer:bottomBorder];
    
    CALayer * leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 0.5, self.frame.size.height);
    leftBorder.backgroundColor = topBorder.backgroundColor;
    [self.layer addSublayer:leftBorder];
    
    CALayer * rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height);
    rightBorder.backgroundColor = topBorder.backgroundColor;
    [self.layer addSublayer:rightBorder];
    
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    [self addSubview:rightImageView];
    [rightImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15.f];
    [rightImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    rightImageView.image = [UIImage imageNamed:@"home_icon_next"];
    
    
}

@end
