//
//  EVNotOpenView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNotOpenView.h"

@implementation EVNotOpenView

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
    UIImageView *topBackImageView = [[UIImageView alloc] init];
    [self addSubview:topBackImageView];
    self.topBackImageView = topBackImageView;
    UIImage *topImage = [UIImage imageNamed:@"ic_smile"];
    [topBackImageView setImage:topImage];
    [topBackImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [topBackImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-22];
    [topBackImageView autoSetDimensionsToSize:CGSizeMake(topImage.size.width, topImage.size.height)];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    textLabel.font = [UIFont textFontB2];
    textLabel.textColor = [UIColor evTextColorH2];
    textLabel.textAlignment  = NSTextAlignmentCenter;
    textLabel.text = @"暂未开通，敬请期待";
    [textLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [textLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 22)];
    [textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topBackImageView];
    
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr  = titleStr;
    self.textLabel.text = titleStr;

}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.topBackImageView setImage:[UIImage imageNamed:imageName]];
}

@end
