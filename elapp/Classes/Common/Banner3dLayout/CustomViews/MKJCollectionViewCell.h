//
//  MKJCollectionViewCell.h
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKJCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *celltitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

@end
