//
//  EVLiveListViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveListViewCell.h"
#import "NSString+Extension.h"


@interface EVLiveListViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

@property (weak, nonatomic) IBOutlet UILabel *liveImage;

@property (weak, nonatomic) IBOutlet UIImageView *liveBackImage;

@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *watchCount;


@end


@implementation EVLiveListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.liveImage.layer.cornerRadius = 4.f;
    self.liveImage.layer.masksToBounds = YES;
    
    self.videoImage.layer.cornerRadius = 4.f;
    self.videoImage.layer.masksToBounds = YES;
    
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo {
    _watchVideoInfo = watchVideoInfo;
    [self.liveBackImage cc_setImageWithURLString:watchVideoInfo.thumb placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
    
    BOOL videoBool = (self.watchVideoInfo.living == 1) ? YES : NO;
    self.liveImage.hidden = !videoBool;
    self.videoImage.hidden = videoBool;
    
    
    self.videoTitle.text = [NSString stringWithFormat:@"%@",watchVideoInfo.title];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",watchVideoInfo.nickname];
    self.watchCount.text = [NSString stringWithFormat:@"%@ 人观看",[NSString shortNumber:watchVideoInfo.watch_count]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
