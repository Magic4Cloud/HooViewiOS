//
//  EVHomeLiveVideoListCollectionViewCell.m
//  elapp
//
//  Created by Ananwu on 2016/10/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#define VideoHeightRote 351.f / 375.f


#import "EVHomeLiveVideoListCollectionViewCell.h"
#import "EVCircleRecordedModel.h"
#import "NSString+Extension.h"
#import "NSDate+Category.h"

@interface EVHomeLiveVideoListCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *videoThumbImgV;
@property (nonatomic, weak) IBOutlet UIButton *videoPlayBtn;
@property (nonatomic, weak) IBOutlet UIImageView *userIconView;
@property (nonatomic, weak) IBOutlet UILabel *videoTitleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userNickNameTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *livingTimeLabel;
@property (nonatomic, weak) IBOutlet UIView *thumbShadowView;

@end

@implementation EVHomeLiveVideoListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.videoThumbImgV.layer.cornerRadius = 2.0f;
    self.videoThumbImgV.layer.masksToBounds = YES;
    
    self.userIconView.layer.shadowColor = CCColor(1, 1, 1).CGColor;
    self.userIconView.layer.shadowOffset = CGSizeMake(2, 2);
    self.userIconView.layer.shadowRadius = 2.0;
    self.userIconView.layer.shadowOpacity = 0.2;
    
    self.thumbShadowView.layer.cornerRadius = 2.0f;
    self.thumbShadowView.layer.shadowColor = CCColor(1, 1, 1).CGColor;
    self.thumbShadowView.layer.shadowOffset = CGSizeMake(3, 3);
    self.thumbShadowView.layer.shadowRadius = 2.0f;
    self.thumbShadowView.layer.shadowOpacity = 0.2f;
    
    self.userIconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIconImg:)];
    [self.userIconView addGestureRecognizer:tapGesture];
    
}

// class method
+ (CGSize)cellSize
{
    return CGSizeMake(ScreenWidth, ScreenWidth * VideoHeightRote + 70);
}
// target
- (IBAction)playBtnBeClickL:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVideo:)]) {
        [self.delegate playVideo:self.model];
    }
}

- (void)tapUserIconImg:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toOtherPersonalUserCenter:)]) {
        [self.delegate toOtherPersonalUserCenter:self.model];
    }
}

#pragma mark - getters and setters

- (void)setModel:(EVCircleRecordedModel *)model
{
    _model = model;
    if ( ![NSString isBlankString:_model.logo_thumb])
    {
        _model.thumb = [_model.logo_thumb mutableCopy];
    }
    [self.videoThumbImgV cc_setImageWithURLString:model.thumb placeholderImage:[UIImage imageNamed:@"home_vedio_conver_placeholder"]];
//    [self.userIconView cc_setImageWithURLString:model.logourl placeholderImage:[UIImage imageNamed:@"home_user_icon_placeholder"]];
    [self.userIconView cc_setRoundImageWithURL:model.logourl placeholderImageName:@"home_user_icon_placeholder"];
    self.videoTitleNameLabel.text = model.title;
    self.userNickNameTitleLabel.text = model.nickname;
    self.livingTimeLabel.text = [self timeLabelTextFromSpan:model.live_stop_time_span];
}

#pragma mark - private method 
- (NSString *)timeLabelTextFromSpan:(NSInteger)span {
    // 将秒数换为文本
//    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] -  span;
//    NSDate *liveStopDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    
//    return [liveStopDate timeIntervalDescription];
    if (span) {
        if (span < 60) {
            return @"刚刚";
        } else if (span < 3600) {
            return [NSString stringWithFormat:@"%d分钟前", (int)(span / 60.00 + 0.50)];
        } else if (span < 86400) {
            return [NSString stringWithFormat:@"%d小时前", (int)(span / 3600.00 + 0.50)];
        } else if (span < 2592000) {//30天内
            return [NSString stringWithFormat:@"%d天前", (int)(span / 86400.00 + 0.50)];
        } else if (span < 31536000) {//30天至1年内
            return [NSString stringWithFormat:@"%d月前", (int)(span / 2592000.00 + 0.50)];
        } else {
            return [NSString stringWithFormat:@"%d年前", (int)(span / 31536000.00 + 0.50)];
        }
    }else {
        return @"刚刚";
    }

}

@end
