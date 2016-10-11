//
//  EVDiscoverNowVideoCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//

#import "EVDiscoverNowVideoCell.h"
#import <PureLayout.h>
#import "EVNowVideoItem.h"
#import "NSString+Extension.h"
#import "EVHeaderView.h"

//#define kMarginTop 10

#define ICONWH 36

@interface EVDiscoverNowVideoCell ()

@property (nonatomic,weak) UIView *containerView;
@property (nonatomic,weak) CCHeaderImageView *icomImageView;
@property (nonatomic,weak) UILabel *nickNameLabel;

@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,weak) UIImageView *thumbImageView;
@property (nonatomic,weak) UIImageView *thumbImageViewTemp;
@property (nonatomic,weak) UIButton *livingBtn;
@property (nonatomic, weak) UIButton *videoTimeBtn;

@property (nonatomic,weak) UILabel *videoTitleLabel;

@property (nonatomic,weak) UIButton *likeCountButton;
@property (nonatomic,weak) UIButton *commontCountButton;
@property (nonatomic,weak) UIButton *watchingCountButton;


@property (weak, nonatomic) NSLayoutConstraint *topConstraint;  /**< 容器距离self顶部的约束 */
@property (weak, nonatomic) NSLayoutConstraint *bottomConstraint;  /**< 容器距离self底部的约束 */

@end

@implementation EVDiscoverNowVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.contentView.backgroundColor = CCBackgroundColor;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:containerView];
    
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [containerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    NSLayoutConstraint *topConstraint = [containerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:CCDiscoverNowVideoCellTopMargin];
    self.topConstraint = topConstraint;
    NSLayoutConstraint *bottomConstraint = [containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    self.bottomConstraint = bottomConstraint;

    self.containerView = containerView;
    
    // 上半部分
    UIView *userInfoContainView = [[UIView alloc] init];
    [containerView addSubview:userInfoContainView];
    userInfoContainView.backgroundColor = [UIColor whiteColor];
    [userInfoContainView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [userInfoContainView autoSetDimension:ALDimensionHeight toSize:50];
    
    CCHeaderImageView *icomImageView = [[CCHeaderImageView alloc] init];
    icomImageView.userInteractionEnabled = YES;
    [userInfoContainView addSubview:icomImageView];
    [icomImageView autoSetDimensionsToSize:CGSizeMake(ICONWH, ICONWH)];
    [icomImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [icomImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    icomImageView.image = [UIImage imageNamed:@"avatar"];
    self.icomImageView = icomImageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
    [icomImageView addGestureRecognizer:tap];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14];
    nickNameLabel.textColor = [UIColor evTextColorH1];
    [userInfoContainView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    [nickNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:icomImageView];
    [nickNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:icomImageView withOffset:10];
    
    

    
    UILabel *timeLabel = [[UILabel alloc] init];
    [userInfoContainView  addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.textColor = [UIColor evAssistColor];
    timeLabel.font = [UIFont systemFontOfSize:13.];;
    [timeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    
    // 下半部分
    UIView *videoContainView = [[UIView alloc] init];
    videoContainView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:videoContainView];
    [videoContainView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [videoContainView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userInfoContainView];
    
    UIView *line = [[UIView alloc] init];
    [videoContainView addSubview:line];
    line.backgroundColor = CCBackgroundColor;
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 0) excludingEdge:ALEdgeBottom];
    [line autoSetDimension:ALDimensionHeight toSize:0.5];
    
    // 缩略图
    // H: 62.5 W: 108
    UIImageView *thumbImageView = [[UIImageView alloc] init];
    thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbImageView.clipsToBounds = YES;
    [videoContainView addSubview:thumbImageView];
    [thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [thumbImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [thumbImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:line];
    [thumbImageView autoSetDimension:ALDimensionWidth toSize:108];
    self.thumbImageView = thumbImageView;
    
    UIImageView *thumbImageViewTemp = [[UIImageView alloc] init];
    thumbImageViewTemp.contentMode = thumbImageView.contentMode;
    thumbImageViewTemp.clipsToBounds = YES;
    thumbImageViewTemp.alpha = 0.0;
    thumbImageView.layer.cornerRadius = 3;
    [thumbImageView addSubview:thumbImageViewTemp];
    [thumbImageViewTemp autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.thumbImageViewTemp = thumbImageViewTemp;
    
    UIButton *livingBtn = [[UIButton alloc] init];
    livingBtn.hidden = YES;
    [livingBtn setTitle:kELiving forState:UIControlStateNormal];
    [thumbImageView addSubview:livingBtn];
    [livingBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [livingBtn autoSetDimension:ALDimensionHeight toSize:18];
    self.livingBtn = livingBtn;
    livingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    livingBtn.backgroundColor = [UIColor colorWithHexString:@"#f54444" alpha:0.5];
    [livingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    livingBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:12];
    
    UIButton *videoTimeBtn = [[UIButton alloc] init];
    [videoTimeBtn setTitleColor:livingBtn.titleLabel.textColor forState:UIControlStateNormal];
    videoTimeBtn.titleLabel.font = livingBtn.titleLabel.font;
    videoTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:0.5];
    videoTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [thumbImageView addSubview:videoTimeBtn];
    self.videoTimeBtn = videoTimeBtn;
    [videoTimeBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [videoTimeBtn autoSetDimension:ALDimensionHeight toSize:18];
    
    UILabel *videoTitleLabel = [[UILabel alloc] init];
    videoTitleLabel.text = kE_Loading;
    videoTitleLabel.textColor = [UIColor evTextColorH1];
    videoTitleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14];
    videoTitleLabel.numberOfLines = 2;
    videoTitleLabel.textAlignment = NSTextAlignmentLeft;
    [videoContainView addSubview:videoTitleLabel];
    [videoTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:thumbImageView withOffset:10];
    [videoTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0f];// 按产品要求修改
    [videoTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:27];
    self.videoTitleLabel = videoTitleLabel;
    
    UIFont *bottomFont = [[CCAppSetting shareInstance] normalFontWithSize:11];
    
    CGFloat margin = 16;
    
    UIButton *likeCountButton = [[UIButton alloc] init];
    likeCountButton.userInteractionEnabled = NO;
    [likeCountButton setImage:[UIImage imageNamed:@"video_list_icon_love"] forState:UIControlStateNormal];
    [likeCountButton setTitle:@"0" forState:UIControlStateNormal];
    likeCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    likeCountButton.titleLabel.font = bottomFont;
    [likeCountButton setTitleColor:CCTextBlackColor forState:UIControlStateNormal];
    [videoContainView addSubview:likeCountButton];
    [likeCountButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:videoTitleLabel];
    [likeCountButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:4]; // 按产品要求修改
    self.likeCountButton = likeCountButton;
    
    UIButton *commontCountButton = [[UIButton alloc] init];
    commontCountButton.userInteractionEnabled = NO;
    [commontCountButton setImage:[UIImage imageNamed:@"video_list_icon_review"] forState:UIControlStateNormal];
    [commontCountButton setTitle:@"0" forState:UIControlStateNormal];
    commontCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    commontCountButton.titleLabel.font = bottomFont;
    [commontCountButton setTitleColor:CCTextBlackColor forState:UIControlStateNormal];
    [videoContainView addSubview:commontCountButton];
    self.commontCountButton = commontCountButton;
    [commontCountButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:likeCountButton withOffset:margin];
    [commontCountButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:likeCountButton];

    UIButton *watchingCountButton = [[UIButton alloc] init];
    watchingCountButton.userInteractionEnabled = NO;
    [watchingCountButton setImage:[UIImage imageNamed:@"video_list_icon_watch"] forState:UIControlStateNormal];
    [watchingCountButton setTitle:@"0" forState:UIControlStateNormal];
    watchingCountButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    watchingCountButton.titleLabel.font = bottomFont;
    [watchingCountButton setTitleColor:CCTextBlackColor forState:UIControlStateNormal];
    [videoContainView addSubview:watchingCountButton];
    self.watchingCountButton = watchingCountButton;
    [watchingCountButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:commontCountButton withOffset:margin];
    [watchingCountButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:commontCountButton];
    
}

- (void)headerTap
{
    if ( [self.delegate respondsToSelector:@selector(discoverCellDidClickHeaderIcon:)] )
    {
        [self.delegate discoverCellDidClickHeaderIcon:self.videoItem];
    }
}

- (void)setVideoItem:(EVNowVideoItem *)videoItem
{
    _videoItem.cell = nil;
    _videoItem.hasAppear = NO;
    _videoItem = videoItem;
    _videoItem.hasAppear = YES;
    _videoItem.cell = self;
    self.thumbImageViewTemp.alpha = 0.0;
    self.thumbImageView.alpha = 1.0;
    [self.thumbImageView cc_setImageWithURLString:videoItem.thumb placeholderImage:[UIImage imageWithALogoWithSize:self.thumbImageView.bounds.size isLiving:NO]];
    
    [self.watchingCountButton setImage:[UIImage imageNamed:@"video_list_icon_watch"] forState:UIControlStateNormal];
    [self.videoTimeBtn setImage:[UIImage imageNamed:@"home_find_video"] forState:UIControlStateNormal];
    [self.livingBtn setImage:[UIImage imageNamed:@"home_find_video"] forState:UIControlStateNormal];

    
    [self updateData];
}

- (void)updateData
{
    [self.icomImageView cc_setRoundImageWithDefaultPlaceHoderURLString:_videoItem.logourl];
    
    [self.icomImageView cc_setImageWithURLString:_videoItem.logourl placeholderImageName:@"avatar" isVip:_videoItem.vid vipSizeType:CCVipMiddle];
    self.nickNameLabel.text = _videoItem.remarks;

    
//    self.watchingCountLabel.hidden = !_videoItem.living;
//    self.timeLabel.hidden = !self.watchingCountLabel.hidden;
    
    self.livingBtn.hidden = !_videoItem.living;
    self.videoTimeBtn.hidden = !self.livingBtn.hidden;
    [self.videoTimeBtn setTitle:[NSString clockTimeDurationWithSpan:[self.videoItem.duration integerValue]] forState:UIControlStateNormal];
    
    if ( _videoItem.living )
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", [NSString shortNumber:_videoItem.watching_count],kEPeople];
    }
    else
    {
        self.timeLabel.text = [NSString timeStampWithStopSpan:_videoItem.live_stop_time_span stopTime:nil];
    }
    
    self.videoTitleLabel.text = _videoItem.title;
    
    [self.likeCountButton setTitle:[NSString shortNumber:_videoItem.like_count] forState:UIControlStateNormal];
    [self.commontCountButton setTitle:[NSString shortNumber:_videoItem.comment_count] forState:UIControlStateNormal];
    [self.watchingCountButton setTitle:[NSString shortNumber:_videoItem.watch_count] forState:UIControlStateNormal];
    
 

}

- (void)updateDataWithAnimation:(EVNowVideoItem *)videoItem
{
    if ( videoItem.updateThumb && videoItem.cell )
    {
        videoItem.updateThumb = NO;
        self.thumbImageViewTemp.image = self.thumbImageView.image;
        [self.thumbImageViewTemp cc_setImageWithURLString:videoItem.thumb placeholderImageName:_videoItem.thumb completeBlock:^(UIImage *image) {
            self.thumbImageView.image = image;
            self.thumbImageViewTemp.alpha = 0.0;
        }];
    }
    _videoItem = videoItem;
    _videoItem.hasAppear = YES;
    
    [self updateData];
}

- (void)setType:(CCDiscoverNowVideoCellTYPE)type
{
    switch (type)
    {
        case CCDiscoverNowVideoCell_NOW:
        {
            self.topConstraint.constant = CCDiscoverNowVideoCellTopMargin;
            self.bottomConstraint.constant = .0f;
        }
            break;
            
        case CCDiscoverNowVideoCell_SEARCH:
        {
            self.topConstraint.constant = .0f;
            self.bottomConstraint.constant = -CCDiscoverNowVideoCellTopMargin;
        }
            break;
    }
}



+ (NSString *)cellID
{
    return @"EVDiscoverNowVideoCell";
}

- (void)setIsFirstCell:(BOOL)isFirstCell
{
    _isFirstCell = isFirstCell;
    if ( _isFirstCell )
    {
        self.topConstraint.constant = 0;
    }
    else
    {
        self.topConstraint.constant = CCDiscoverNowVideoCellTopMargin;
    }
}

@end
