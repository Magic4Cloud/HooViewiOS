//
//  MKJCollectionViewCell.m
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJCollectionViewCell.h"

@implementation MKJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.heroImageVIew.layer.cornerRadius = 5.0f;
//    self.heroImageVIew.layer.masksToBounds = YES;
//    self.backView.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.3;
    self.imageView.layer.shadowRadius = 1.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
//    self.backView.layer.cornerRadius = 15.0;
    self.imageView.layer.masksToBounds = NO;
}

@end
