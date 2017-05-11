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
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.3;
    self.imageView.layer.shadowRadius = 1.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.imageView.layer.masksToBounds = NO;
    
}

@end
