//
//  EVRecoredItemCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVRecoredItemCell.h"
#import "NSString+Extension.h"

@interface EVRecoredItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *watchNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *VideoTitle;

@property (weak, nonatomic) IBOutlet UILabel *VideoTime;

@property (weak, nonatomic) IBOutlet UIImageView *PauseImage;

@end

@implementation EVRecoredItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor evBackgroundColor];
    
    [self setUpView];
}

- (void)setUpView
{
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 22;
    self.PauseImage.image = [UIImage imageNamed:@"btn_play_n"];
    
    
}


- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    [self.headImage cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    self.nameLabel.text = watchVideoInfo.nickname;
    self.watchNumLabel.text = [NSString stringWithFormat:@"%@ 人观看", [NSString shortNumber:watchVideoInfo.watch_count]];
    self.VideoTitle.text = watchVideoInfo.title;
    [self.backImage cc_setImageWithURLString:watchVideoInfo.thumb placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    NSString *timeS = [self timeFormatted:watchVideoInfo.duration];

    
    self.VideoTime.text = timeS;
}

- (NSString *)timeFormatted:(NSInteger)time
{
    NSString *timeStr = nil;
    
    NSInteger secondsInteger = (time) % 60;
    NSInteger minuterInteger = (time) / 60;
    
    return [NSString stringWithFormat:@"%ld分%ld秒",minuterInteger,secondsInteger];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
