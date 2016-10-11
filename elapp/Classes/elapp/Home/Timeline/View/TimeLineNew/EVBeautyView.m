//
//  EVBeautyView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBeautyView.h"
#import <PureLayout/PureLayout.h>
#import "EVHeaderView.h"
#import "NSString+Extension.h"
#import "EVCircleRecordedModel.h"

#define CCBeatyCollectionViewCellHeaderH 60.0f
#define CCBeatyCollectionViewCellTailH 40.0f
#define kMarginLeft 15.0f

@interface EVBeautyView ()

@property (weak, nonatomic) EVHeaderButton *avatarBtn;              /**< 头像 */
@property (weak, nonatomic) UILabel *nicknameLbl;                   /**< 昵称 */
@property (weak, nonatomic) UILabel *watchingCountLbl;              /**< 正在观看数 */
@property ( weak, nonatomic ) UILabel *startTimeLabel;              /**< 直播开始时间 */

@property ( weak, nonatomic ) UILabel *liveTitleLabel;                /**< 直播名称 */

@end

@implementation EVBeautyView

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addCustomSubviews];
    }
    
    return self;
}


#pragma mark - action response

- (void)avatarClicked
{
    if ( self.avatarClick )
    {
        self.avatarClick(self.model);
    }
}

#pragma mark - private methods

- (void)addCustomSubviews
{
    // 头像、昵称、地址、观看人数
    UIView *headerContainerV = [[UIView alloc] init];
    headerContainerV.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerContainerV];
    [headerContainerV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [headerContainerV autoSetDimension:ALDimensionHeight toSize:CCBeatyCollectionViewCellHeaderH];
    
    EVHeaderButton *avatarBtn = [[EVHeaderButton alloc] init];
    [avatarBtn addTarget:self action:@selector(avatarClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerContainerV addSubview:avatarBtn];
    self.avatarBtn = avatarBtn;
//    avatarBtn.layer.borderColor = [UIColor evMainColor].CGColor;
//    avatarBtn.layer.borderWidth = 1.f;
    avatarBtn.layer.cornerRadius = 21;
    avatarBtn.clipsToBounds = YES;
    [avatarBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kMarginLeft];
    [avatarBtn autoSetDimension:ALDimensionWidth toSize:42.0f];
    [avatarBtn autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:avatarBtn];
    [avatarBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UILabel *nicknameLbl = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH1] font:CCNormalFont(14.0f)];
    nicknameLbl.textAlignment = NSTextAlignmentLeft;
    nicknameLbl.contentMode = UIViewContentModeTop;
    nicknameLbl.numberOfLines = 1;
    [headerContainerV addSubview:nicknameLbl];
    self.nicknameLbl = nicknameLbl;
    [nicknameLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:avatarBtn];
    [nicknameLbl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70.0f];
    [nicknameLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarBtn withOffset:kMarginLeft];
    
    
    UILabel *watchingCountLbl = [UILabel labelWithDefaultTextColor:[UIColor colorWithHexString:@"#fb6655" alpha:1.0f] font:CCNormalFont(14.0f)];
    watchingCountLbl.textAlignment = NSTextAlignmentRight;
    watchingCountLbl.numberOfLines = 1;
    [headerContainerV addSubview:watchingCountLbl];
    self.watchingCountLbl = watchingCountLbl;
    [watchingCountLbl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft];
    [watchingCountLbl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:nicknameLbl withOffset:.0f];
    

    // 视频封面、开始时间、录播时长、直/录播状态图、密码锁
    UIImageView *videoImgV = [[UIImageView alloc] init];
    [self addSubview:videoImgV];
    videoImgV.userInteractionEnabled = YES;
    self.videoImgV = videoImgV;
    videoImgV.contentMode = UIViewContentModeScaleAspectFill;
    videoImgV.clipsToBounds = YES;
    [videoImgV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headerContainerV];
    [videoImgV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [videoImgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [videoImgV autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:videoImgV];
    
    
    
    UIColor *shadowColor = [UIColor colorWithHexString:@"#000000" alpha:.5f];
    CGSize shadowOffset = CGSizeMake(.3f, .3f);
    
    UILabel *startTimeLabel = [[UILabel alloc] init];
    [videoImgV addSubview:startTimeLabel];
    startTimeLabel.font = [UIFont systemFontOfSize:14];
    startTimeLabel.textColor = [UIColor whiteColor];
    startTimeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    startTimeLabel.layer.borderWidth = 1;
    startTimeLabel.layer.cornerRadius = 3;
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [startTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft];
    [startTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kMarginLeft];
    [startTimeLabel autoSetDimension:ALDimensionWidth toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
    [startTimeLabel autoSetDimension:ALDimensionHeight toSize:20];
    _startTimeLabel = startTimeLabel;
    startTimeLabel.shadowOffset = shadowOffset;
    startTimeLabel.shadowColor = shadowColor;
    

    // tail容器、直播类型、直播标题
    UIView *tailContainerV = [[UIView alloc] init];
    tailContainerV.backgroundColor = [UIColor whiteColor];
    [self addSubview:tailContainerV];
    [tailContainerV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, kMarginLeft, .0f) excludingEdge:ALEdgeTop];
    [tailContainerV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:videoImgV];
    
    
    
    UILabel *liveTitleLabel = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH1] font:CCNormalFont(14.0f)];
    [tailContainerV addSubview:liveTitleLabel];
    [liveTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kMarginLeft / 2.0f];
    [liveTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15.0f];
    [liveTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    liveTitleLabel.numberOfLines = 1;
    _liveTitleLabel = liveTitleLabel;
}


#pragma mark - getters and setters

- (void)setModel:(EVCircleRecordedModel *)model
{
    _model = model;
    if ( ![NSString isBlankString:_model.logo_thumb]  )
    {
        _model.thumb = [_model.logo_thumb mutableCopy];
    }
    
    [self.videoImgV cc_setImageWithURLString:model.thumb placeholderImage:[UIImage imageWithALogoWithSize:CGSizeMake(ScreenWidth, ScreenWidth)isLiving:model.living]];
    
    [self.avatarBtn cc_setBackgroundImageURL:model.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:model.vip vipSizeType:CCVipMini];
    
    [self.nicknameLbl setText:model.nickname];
    self.liveTitleLabel.text = model.title;
    
    if ( model.living )
    {
        self.startTimeLabel.text = kVideoLiving;
        self.watchingCountLbl.text = [NSString stringWithFormat:@"%@%@", [NSString shortNumber:model.watching],kEPeople];
    }
    else
    {
        self.startTimeLabel.text = kVideoPlayback;
        self.watchingCountLbl.text = [NSString stringWithFormat:@"%@%@", [NSString shortNumber:model.watch],kEPeople];
    }
}

@end
