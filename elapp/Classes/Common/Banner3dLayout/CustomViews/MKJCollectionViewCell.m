//
//  MKJCollectionViewCell.m
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJCollectionViewCell.h"
@interface MKJCollectionViewCell()
@property (nonatomic, strong)CAGradientLayer *gradient;
@end

@implementation MKJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.3;
    self.imageView.layer.shadowRadius = 1.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.imageView.layer.masksToBounds = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _bottomBgView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                       (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor,
                       (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,
                       (id)[UIColor colorWithWhite:0 alpha:0.6].CGColor, nil];
    [_bottomBgView.layer addSublayer:gradient];
    _gradient = gradient;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _gradient.frame = _bottomBgView.bounds;
}
@end
