//
//  EVHotListCollectionViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/15.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHotListCollectionViewCell.h"

@interface EVHotListCollectionViewCell ()

@property (nonatomic, weak) UIImageView *backImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *watch_countLabel;

@end

@implementation EVHotListCollectionViewCell

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
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self addSubview:backImageView];
    self.backImageView = backImageView;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.layer.masksToBounds = YES;
    self.backImageView.image = [UIImage imageNamed:@"Account_bitmap_list"];
    [backImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [backImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [backImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [backImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:26];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.4;
    [backImageView addSubview:backView];
    [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [backView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [backView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [backView autoSetDimension:ALDimensionHeight toSize:22];

    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont textFontB2];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [nameLabel autoSetDimension:ALDimensionHeight toSize:22];
//    nameLabel.frame = CGRectMake(5, 5, itemCell.frame.size.width - 10, 50);
//    nameLabel.text = watchVideoInfo.title;
    
    
    UIImageView *ishotImage = [[UIImageView alloc] init];
    [self addSubview:ishotImage];
    self.ishotImage = ishotImage;
    ishotImage.image = [UIImage imageNamed:@"ic_hot"];
    [ishotImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:6];
    [ishotImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:29];
    [ishotImage autoSetDimensionsToSize:CGSizeMake(16, 16)];

    
    UILabel *watch_countLabel = [[UILabel alloc] init];
    [self addSubview:watch_countLabel];
    self.watch_countLabel = watch_countLabel;
    watch_countLabel.textColor = [UIColor whiteColor];
    watch_countLabel.font = [UIFont systemFontOfSize:14.f];
    [_watch_countLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:23];
    [_watch_countLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:27];
    [_watch_countLabel autoSetDimension:ALDimensionHeight toSize:20];
    
    
    UIImageView * eyeImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_live_watch"]];
    [self addSubview:eyeImageView];
    [eyeImageView autoSetDimensionsToSize:CGSizeMake(22, 22)];
    [eyeImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:27];
    [eyeImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];

}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self.backImageView cc_setImageWithURLString:watchVideoInfo.thumb placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
    [self.nameLabel setText:watchVideoInfo.title];

    NSString *watch_count = [NSString stringWithFormat:@"%ld",(unsigned long)watchVideoInfo.watch_count];
    _watch_countLabel.text = [NSString stringWithFormat:@"%@人观看",[watch_count thousandsSeparatorString]];
    
    if (watchVideoInfo.watch_count < 10000)
    {
        _ishotImage.hidden = YES;
    }
    else
    {
        _ishotImage.hidden = NO;
    }
    
}
@end
