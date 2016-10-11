//
//  EVLiveVideoView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLiveVideoView.h"
#import "EVHeaderView.h"
#import <PureLayout.h>
#include "EVCircleRecordedModel.h"
#import "NSString+Extension.h"
#import <SDImageCache.h>
#import "SDWebImageManager.h"

#define kMarginLeft 10.0f

@interface EVLiveVideoView ()

@property ( weak, nonatomic ) UIImageView *bgImageView;             /**< 背景图片 */
@property (nonatomic, weak) UIImageView *bgImageViewTemp;           /**< 临时背景图，用来做图片切换 */
@property ( weak, nonatomic ) CCHeaderImageView *headImageView;     /**< 头像 */
@property ( weak, nonatomic ) UILabel *nickNameLabel;               /**< 用户昵称 */
@property ( weak, nonatomic ) UIButton *locationBtn;                /**< 地理位置 */
@property (nonatomic, weak) UILabel *distanceLabel;                 /**< 距离label */
@property ( weak, nonatomic ) UILabel *startTimeLabel;              /**< 直播开始时间 */
@property ( weak, nonatomic ) UILabel *intervelLabel;               /**< 直播时长 */
@property ( weak, nonatomic ) UIButton *accompanyBtn;               /**< 陪伴按钮 */
@property ( weak, nonatomic ) UILabel *liveTitleLabel;              /**< 直播名称 */
@property ( weak, nonatomic ) UIButton *watchCountBtn;              /**< 观看数 */
@property ( weak, nonatomic ) UIButton *praiseCountBtn;             /**< 点赞数 */
@property ( weak, nonatomic ) UIButton *commentCountBtn;            /**< 评论数 */
@property ( weak, nonatomic ) UIImageView *markLiveIcon;            /**< 标记直播图标 */
@property ( weak, nonatomic ) UIImageView *typeIcon;                /**< 直播类型(视频|音频) */
@property ( weak, nonatomic ) UIImageView *pwdLockerImgV;           /**< 密码锁 */


@end

@implementation EVLiveVideoView

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addCustomSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
}


#pragma mark - private methods

- (void)addCustomSubviews
{
    // 背景图
    UIImageView *bgImageViewTemp = [[UIImageView alloc] init];
    bgImageViewTemp.image = [UIImage imageNamed:@"home_pic_loadbackground_blue"];
    bgImageViewTemp.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageViewTemp setClipsToBounds:YES];
    [self addSubview:bgImageViewTemp];
    _bgImageViewTemp = bgImageViewTemp;
    [bgImageViewTemp autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [bgImageViewTemp autoSetDimension:ALDimensionHeight toSize:230];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self addSubview:bgImageView];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    _bgImageView = bgImageView;
    [bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [bgImageView autoSetDimension:ALDimensionHeight toSize:230];
    
    // 头像
    CCHeaderImageView *headImageView = [[CCHeaderImageView alloc] init];
    [self addSubview:headImageView];
    _headImageView = headImageView;
    headImageView.userInteractionEnabled = YES;
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kMarginLeft];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kMarginLeft];
    [headImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
    headImageView.layer.cornerRadius = 15;
    
    // 头像单击手势
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [headImageView addGestureRecognizer:tapHead];
    
    UIColor *shadowColor = [UIColor colorWithHexString:@"#000000" alpha:.5f];
    CGSize shadowOffset = CGSizeMake(.3f, .3f);
    // 用户昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    [self addSubview:nickNameLabel];
    [nickNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:5.];
    [nickNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kMarginLeft];
    _nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:13];
    nickNameLabel.shadowColor = shadowColor;
    nickNameLabel.shadowOffset = shadowOffset;
    
    // 地理位置
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:locationBtn];
    [locationBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headImageView withOffset:0.];
    [locationBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLabel];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [locationBtn setImage:[UIImage imageNamed:@"timeline_icon_gps"] forState:UIControlStateNormal];
    _locationBtn = locationBtn;
    [locationBtn setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [locationBtn.titleLabel setShadowOffset:shadowOffset];
    
    // 离主播的距离
    UILabel *distanceLabel = [UILabel labelWithDefaultShadowTextColor:[UIColor whiteColor] font:CCNormalFont(13.0f)];
    [self addSubview:distanceLabel];
    _distanceLabel = distanceLabel;
    [distanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:locationBtn withOffset:2];
    [distanceLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationBtn];
    
    // 直播开始时间
    UILabel *startTimeLabel = [[UILabel alloc] init];
    [self addSubview:startTimeLabel];
    [startTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft];
    [startTimeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nickNameLabel];
    startTimeLabel.font = [UIFont systemFontOfSize:10];
    startTimeLabel.textColor = [UIColor whiteColor];
    startTimeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    startTimeLabel.layer.borderWidth = 1;
    startTimeLabel.layer.cornerRadius = 8;
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [startTimeLabel autoSetDimension:ALDimensionWidth toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
    [startTimeLabel autoSetDimension:ALDimensionHeight toSize:16];
    _startTimeLabel = startTimeLabel;
    startTimeLabel.shadowOffset = shadowOffset;
    startTimeLabel.shadowColor = shadowColor;
    
    // 直播时长
    UILabel *intervelLabel = [[UILabel alloc] init];
    [self addSubview:intervelLabel];
    [intervelLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:startTimeLabel];
    [intervelLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationBtn];
    intervelLabel.font = [UIFont systemFontOfSize:10];
    intervelLabel.textColor = [UIColor whiteColor];
    _intervelLabel = intervelLabel;
    intervelLabel.shadowColor = shadowColor;
    intervelLabel.shadowOffset = shadowOffset;
    
    // 陪伴
    UIButton *accompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:accompanyBtn];
    [accompanyBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgImageView withOffset: - 10.];
    [accompanyBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.];
    _accompanyBtn = accompanyBtn;
    [accompanyBtn setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
    
    // 标记直播图标
    UIImageView *markLiveIcon = [[UIImageView alloc] init];
    [self addSubview:markLiveIcon];
    [markLiveIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.];
    [markLiveIcon autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgImageView];
    _markLiveIcon = markLiveIcon;
    
    // 密码锁
    UIImageView *pwdLockerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"limit_icon_private"]];
    [markLiveIcon addSubview:pwdLockerImgV];
    _pwdLockerImgV = pwdLockerImgV;
    [pwdLockerImgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3.0f];
    [pwdLockerImgV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:4.0f];
    
    // 直播标题
    UILabel *liveTitleLabel = [[UILabel alloc ]init];
    [self addSubview:liveTitleLabel];
    [liveTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft];
    [liveTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kMarginLeft];
    [liveTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bgImageView withOffset:5.];
    liveTitleLabel.numberOfLines = 1;
    liveTitleLabel.font = [UIFont systemFontOfSize:15.];
    liveTitleLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
    _liveTitleLabel = liveTitleLabel;
    
    // 直播类型
    UIImageView *typeIcon = [[UIImageView alloc]init];
    [self addSubview:typeIcon];
    [typeIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft];
    [typeIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:liveTitleLabel withOffset:4.];
    _typeIcon = typeIcon;
    
    // 按钮字体
    UIFont *btnFont = [UIFont systemFontOfSize:10];
    // 按钮颜色
    UIColor *btnColor = [UIColor colorWithHexString:@"#403b37"];
    
    // 评论数
    UIButton *commentCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:commentCountBtn];
    [commentCountBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:typeIcon withOffset: - 20];
    [commentCountBtn autoSetDimension:ALDimensionWidth toSize:60];
    [commentCountBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:typeIcon];
    commentCountBtn.titleLabel.font = btnFont;
    commentCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentCountBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [commentCountBtn setImage:[UIImage imageNamed:@"timeline_icon_review"] forState:UIControlStateNormal];
    _commentCountBtn = commentCountBtn;
    
    // 点赞数
    UIButton *praiseCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:praiseCountBtn];
    [praiseCountBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:commentCountBtn withOffset:-10.];
    [praiseCountBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:commentCountBtn];
    [praiseCountBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:typeIcon];
    praiseCountBtn.titleLabel.font = btnFont;
    praiseCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [praiseCountBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [praiseCountBtn setImage:[UIImage imageNamed:@"timeline_icon_love"] forState:UIControlStateNormal];
    _praiseCountBtn = praiseCountBtn;
    
    // 观看数
    UIButton *watchCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:watchCountBtn];
    [watchCountBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:praiseCountBtn withOffset:-10.];
    [watchCountBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:typeIcon];
    [watchCountBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:commentCountBtn];
    watchCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    watchCountBtn.titleLabel.font = btnFont;
    [watchCountBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [watchCountBtn setImage:[UIImage imageNamed:@"timeline_icon_watch"] forState:UIControlStateNormal];
    self.watchCountBtn = watchCountBtn;
}

// 单击手势响应方法
- (void) tapImage:(UITapGestureRecognizer *)recognizer
{
    if ( !self.delegate )
    {
        return;
    }
    if ( [self.delegate respondsToSelector:@selector(clickHeadImageForVideo:)] && recognizer.view == self.headImageView )
    {
        [self.delegate clickHeadImageForVideo:self.model];
    }
    if ( [self.delegate respondsToSelector:@selector(clickThumbImageForVideo:)] && recognizer.view == self.bgImageView )
    {
        [self.delegate clickThumbImageForVideo:self.model];
    }
}

- (void)replaceThumbWithLastModel:(EVCircleRecordedModel *)lastModel newModel:(EVCircleRecordedModel *)newModel
{
    [self setInfoWithModel:newModel];
    

    
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:lastModel.thumb]];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
    
    if ( image == nil )
    {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
    }
    
    if ( image )
    {
        self.bgImageView.image = image;
        self.bgImageView.alpha = 1;
//        [UIView animateWithDuration:0.1 animations:^{
//            self.bgImageView.alpha = 1;
//        }];
    }
    else
    {
        
    }
    [self.bgImageViewTemp cc_setImageWithURLString:newModel.thumb placeholderImage:nil complete:^(UIImage *image) {
        self.bgImageView.alpha = 0;
        self.bgImageView.image = image;
        [UIView animateWithDuration:0.1 animations:^{
            self.bgImageView.alpha = 1;
        }];
    }];
    
    
}

- (void)setInfoWithModel:(EVCircleRecordedModel *)model
{
    [self.watchCountBtn setTitle:[NSString stringWithFormat:@"%@",[NSString shortNumber:model.watch]] forState:UIControlStateNormal];
    [self.praiseCountBtn setTitle:[NSString stringWithFormat:@"%@",[NSString shortNumber:model.like_count]] forState:UIControlStateNormal];
//    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%@",[NSString shortNumber:model.comment_count]] forState:UIControlStateNormal];
    
    if ( model.living )
    {
        self.startTimeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.startTimeLabel.text = @"living";
        self.intervelLabel.text =  [NSString stringWithFormat:@"%@人 %@", [NSString shortNumber:model.watching],kWatch];
        self.markLiveIcon.image = [UIImage imageNamed:@"mark_live"];
    }
    else
    {
        self.startTimeLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.startTimeLabel.text = [NSString timeStampWithStopSpan:model.live_stop_time_span stopTime:model.live_stop_time];
        self.intervelLabel.text = [NSString stringFormattedTimeFromDuration:@(model.duration)];
        self.markLiveIcon.image = [UIImage imageNamed:@"mark_playback"];
    }
}

- (void)setModel:(EVCircleRecordedModel *)model
{
    _model = model;
    
    [self setInfoWithModel:model];
    
    [self.bgImageView cc_setImageWithURLString:model.thumb placeholderImage:[UIImage imageWithALogoWithSize:self.bgImageView.bounds.size isLiving:NO]];
    
    [self.headImageView cc_setImageWithURLString:model.logourl placeholderImageName:@"avatar" isVip:(model.vip==0?NO:YES) vipSizeType:CCVipMini];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nickname];
    [self.locationBtn setTitle:model.location forState:UIControlStateNormal];
    
    UIImage *typeImage =  [UIImage imageNamed:@"timeline_icon_video"];
    self.typeIcon.image = typeImage;
    [self.watchCountBtn setImage:[UIImage imageNamed:(@"timeline_icon_watch")] forState:UIControlStateNormal];
    
    self.distanceLabel.text = [NSString convertDistanceNumber:[model.distance integerValue]];
    if (model.showDistance)
    {
        self.distanceLabel.hidden = NO;
    }
    else
    {
        self.distanceLabel.hidden = YES;
    }
    self.liveTitleLabel.text = model.title;
    self.accompanyBtn.hidden = !model.accompany;
}

@end
