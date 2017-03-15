//
//  EVMyVideoTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMyVideoTableViewCell.h"
#import "EVUserVideoModel.h"
#import "NSString+Extension.h"
#import <PureLayout.h>

@interface EVMyVideoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;                // 标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;   // 时间戳     // 权限
@property (weak, nonatomic) IBOutlet UILabel *watchCount;            // 点赞数、观看数、评论数
@property (weak, nonatomic) IBOutlet UIImageView *playbackImage;

@property (weak, nonatomic) IBOutlet UIImageView *liveImage;

@property (weak, nonatomic) IBOutlet UILabel *videoDuration;
@property (weak, nonatomic) UILabel * verifyLabel;
@property (weak, nonatomic) IBOutlet UIButton *permissionButton;


@end

@implementation EVMyVideoTableViewCell

#pragma mark - life circle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configUI];
}


#pragma mark - event response


#pragma mark - private methods

- (void)configUI
{
//    self.videoDuration.font = [[EVAppSetting shareInstance] normalFontWithSize:10.0f];
//    self.stampAndWatchCount.font = [[EVAppSetting shareInstance] normalFontWithSize:13.0f];
//    self.stampAndWatchCount.textColor = [UIColor evTextColorH1];
//    self.title.font = [[EVAppSetting shareInstance] normalFontWithSize:13.0f];
//    self.title.textColor = [UIColor evTextColorH1];
//    self.videoShot.backgroundColor = [UIColor greenColor];
//    self.videoShot.contentMode = UIViewContentModeScaleAspectFill;
    self.playbackImage.layer.cornerRadius = 4;
    self.playbackImage.clipsToBounds = YES;
}


- (void)buttonAction:(UIButton *)btn 
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoTableViewButton:videoCell:)]) {
        [self.delegate videoTableViewButton:btn videoCell:self];
    }
}
#pragma mark - getters and setters
// 重写setter方法，根据model数据来展示cell
- (void)setVideoModel:(EVWatchVideoInfo *)videoModel{
    _videoModel = videoModel;
    
    // 视频截图
    [self.videoShot cc_setImageWithURLString:self.videoModel.thumb placeholderImage:[UIImage imageWithALogoWithSize:self.videoShot.bounds.size isLiving:NO] complete:nil];
    self.playbackImage.hidden = videoModel.living == 1 ? YES : NO;
    self.liveImage.hidden = videoModel.living == 1 ? NO : YES;
    // 视频标题
    NSString *liveTitle = [EVAppSetting liveTitleWithNickName:self.videoModel.nickname CurrentTitle:self.videoModel.title isLive:self.videoModel.living ];
//    [self.title cc_setEmotionWithText:liveTitle];
    CCCellType type = CCCellTypeVideo;
  
    type = CCCellTypeVideo;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",videoModel.title];
  
    NSString *WatchS = [NSString numFormatNumber:videoModel.duration];
    self.watchCount.text = [NSString stringWithFormat:@"%@人观看",WatchS];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@",videoModel.live_start_time];

    
    
    
    BOOL isVerify = self.videoModel.status == 2;
    self.verifyLabel.text = kE_GlobalZH(@"video_check");
    
    self.verifyLabel.hidden = !isVerify;
    self.videoDuration.hidden = isVerify;
    self.videoShot.bottomMaskLayer.hidden = isVerify;
}

@end
