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

@property (nonatomic, weak) UILabel *timeLabel;

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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self addSubview:backImageView];
    self.backImageView = backImageView;
    self.backImageView.image = [UIImage imageNamed:@"Account_bitmap_list"];
     [backImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 2;
    nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont textFontB2];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [nameLabel autoSetDimension:ALDimensionHeight toSize:50];
//    nameLabel.frame = CGRectMake(5, 5, itemCell.frame.size.width - 10, 50);
//    nameLabel.text = watchVideoInfo.title;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:14.f];
    timeLabel.frame = CGRectMake(5, 88-30, 100, 25);
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self.backImageView cc_setImageWithURLString:watchVideoInfo.thumb placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
    [self.nameLabel setText:watchVideoInfo.title];
    
    
//    NSString *timeStr = [NSString stringWithFormat:@"%@",watchVideoInfo.live_start_time];
//    timeStr =   [timeStr substringToIndex:10];
//    NSString *lTime = [NSString stringWithFormat:@"%@.%@",[timeStr substringWithRange:NSMakeRange(5, 2)],[timeStr substringWithRange:NSMakeRange(8, 2)]];
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",lTime];
    
}
@end
