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

@property (weak, nonatomic) IBOutlet UILabel *title;                // 标题
@property (weak, nonatomic) IBOutlet UILabel *stampAndWatchCount;   // 时间戳     // 权限
@property (weak, nonatomic) IBOutlet UILabel *likeCount;            // 点赞数、观看数、评论数
@property (weak, nonatomic) IBOutlet UILabel *videoDuration;
@property (weak, nonatomic) UILabel * verifyLabel;

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
    self.videoDuration.font = [[CCAppSetting shareInstance] normalFontWithSize:10.0f];
    self.stampAndWatchCount.font = [[CCAppSetting shareInstance] normalFontWithSize:13.0f];
    self.stampAndWatchCount.textColor = [UIColor evTextColorH1];
    self.title.font = [[CCAppSetting shareInstance] normalFontWithSize:13.0f];
    self.title.textColor = [UIColor evTextColorH1];
    self.videoShot.contentMode = UIViewContentModeScaleAspectFill;
    [self addTopSeparatorLine];
    
    UILabel * verify = [[UILabel alloc] init];
    verify.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    verify.textAlignment = NSTextAlignmentCenter;
    verify.textColor = [UIColor whiteColor];
    verify.font = [UIFont systemFontOfSize:12];
    verify.text = kE_GlobalZH(@"video_check");
    [self.videoShot addSubview:verify];
    [verify autoPinEdgesToSuperviewEdges];
    self.verifyLabel = verify;
    self.verifyLabel.hidden = YES;
}

/**
 *  添加cell顶部的分割线
 */
- (void)addTopSeparatorLine
{
    UIView *topSeparatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    topSeparatorLine.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [self.contentView addSubview:topSeparatorLine];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [topSeparatorLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [topSeparatorLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    [self.contentView layoutIfNeeded];
}


#pragma mark - getters and setters
// 重写setter方法，根据model数据来展示cell
- (void)setVideoModel:(EVUserVideoModel *)videoModel{
    _videoModel = videoModel;
    
    // 视频截图
    [self.videoShot cc_setImageWithURLString:self.videoModel.thumb placeholderImage:[UIImage imageWithALogoWithSize:self.videoShot.bounds.size isLiving:NO] complete:nil];
    
    // 视频标题
    NSString *liveTitle = [CCAppSetting liveTitleWithNickName:self.videoModel.nickname CurrentTitle:self.videoModel.title isLive:[self.videoModel.living boolValue]];
    [self.title cc_setEmotionWithText:liveTitle];
    CCCellType type = CCCellTypeVideo;
  
    type = CCCellTypeVideo;
    
    if ( ScreenWidth >= 375.0f )
    {
        [self.likeCount setAttributeTextWithWatch:self.videoModel.watch_count like:self.videoModel.like_count comment:self.videoModel.comment_count fontSize:10.0f titleToTitleWhitespaceNumbers:3 type:type];
    }
    else
    {
        [self.likeCount setAttributeTextWithWatch:self.videoModel.watch_count like:self.videoModel.like_count comment:self.videoModel.comment_count fontSize:10.0f titleToTitleWhitespaceNumbers:1 type:type];
    }
    
    // 时间戳
    self.stampAndWatchCount.text = [NSString dateTimeStampWithStoptime:self.videoModel.live_start_time];
    
    // 视频时长
    self.videoDuration.text = [NSString clockTimeDurationWithSpan:self.videoModel.duration];
    
    
    BOOL isVerify = self.videoModel.status == 2;
    self.verifyLabel.text = kE_GlobalZH(@"video_check");
    
    self.verifyLabel.hidden = !isVerify;
    self.videoDuration.hidden = isVerify;
    self.videoShot.bottomMaskLayer.hidden = isVerify;
}

@end
