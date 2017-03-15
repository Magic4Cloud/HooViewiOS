//
//  EVTopContributorView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTopContributorView.h"
#import "EVFantuanContributorModel.h"
#import "EVHeaderView.h"
#import <PureLayout/PureLayout.h>
#import "EVNickNameAndLevelView.h"

@interface EVTopContributorView ()

@property (weak, nonatomic) UILabel *listNumLbl;  /**< 排名 */
@property (weak, nonatomic) EVHeaderButton *logoBtn;  /**< 头像按钮 */
@property (weak, nonatomic) EVNickNameAndLevelView *nicknameLbl;  /**< 昵称 */
@property (weak, nonatomic) UILabel *contributesLbl;  /**< 云票贡献量 */
@property (weak, nonatomic) UIImageView *topImgV;  /**< 外框 */
@property (weak, nonatomic) NSLayoutConstraint *logoH;  /**< 头像高度 */
@property (weak, nonatomic) NSLayoutConstraint *logoT;
@property (weak, nonatomic) UIImageView *crownImgV;
@property (weak, nonatomic) UIImageView *numImgV;

@end

@implementation EVTopContributorView

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setUpUI];
    }
    
    return self;
}


#pragma mark - event responds

- (void)avatarClick
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(logoClicked:)] )
    {
        [self.delegate logoClicked:self.model];
    }
}


#pragma mark - private methods

- (void)setUpUI
{
    UILabel *contributesLbl = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH2]
                                                            font:EVNormalFont(13)];
    contributesLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contributesLbl];
    self.contributesLbl = contributesLbl;
    [contributesLbl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [contributesLbl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.0f];
        
     EVNickNameAndLevelView *nicknameLbl = [[EVNickNameAndLevelView alloc] init];
    [self addSubview:nicknameLbl];
    self.nicknameLbl = nicknameLbl;
    [nicknameLbl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nicknameLbl autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:contributesLbl withOffset:-13.0f];
    
    EVHeaderButton *logoBtn = [[EVHeaderButton alloc] init];
    [logoBtn addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logoBtn];
    self.logoBtn = logoBtn;
    [logoBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.logoT = [logoBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    self.logoH = [logoBtn autoSetDimension:ALDimensionHeight toSize:75];
    [logoBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:logoBtn];

    UIImageView *topImgV = [[UIImageView alloc] init];
    [self addSubview:topImgV];
    self.topImgV = topImgV;
    [topImgV autoAlignAxis:ALAxisVertical toSameAxisOfView:logoBtn];
    [topImgV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:logoBtn];
    
    UIImageView *crownImgV = [[UIImageView alloc] init];
    crownImgV.image = [UIImage imageNamed:@"list_icon_crown"];
    [self addSubview:crownImgV];
    self.crownImgV = crownImgV;
    [crownImgV autoAlignAxis:ALAxisVertical toSameAxisOfView:logoBtn];
    [crownImgV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:logoBtn];
    crownImgV.hidden = YES;
    
    UIImageView *numImgV = [[UIImageView alloc] init];
    [self addSubview:numImgV];
    self.numImgV = numImgV;
    [numImgV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [numImgV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
}


#pragma mark - getters and setters

- (void)setModel:(EVFantuanContributorModel *)model
{
    _model = model;
    
    [self.logoBtn cc_setBackgroundImageURL:model.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:![model.vip isEqualToString:@"0"] vipSizeType:EVVipMiddle];
    self.nicknameLbl.nickName = model.nickname;
    self.nicknameLbl.gender = model.gender;
    self.contributesLbl.text = [NSString stringWithFormat:@"%@ %zd",kE_GlobalZH(@"e_devote"), model.riceroll];
}

- (void)setType:(CCTopContributorType)type
{
    CALayer * bottomBorder = [CALayer layer];
    [bottomBorder setBackgroundColor:[UIColor evGlobalSeparatorColor].CGColor];
    [self.layer addSublayer:bottomBorder];
    switch ( type )
    {
        case CCTopContributorTop1:
        {
            [self autoSetDimension:ALDimensionHeight toSize:137.5];
            self.logoH.constant = 57;
            self.logoBtn.layer.cornerRadius = 57.f/2.f;
            self.logoT.constant = 23;
            [self.topImgV setImage:[UIImage imageNamed:@"list_icon_1"]];
            [self.numImgV setImage:[UIImage imageNamed:@"list_icon_medal_1"]];
            bottomBorder.frame = CGRectMake(0, 138-1, ScreenWidth, 0.5f);
        }
            break;
            
        case CCTopContributorTop2:
        {
            [self autoSetDimension:ALDimensionHeight toSize:115];
            self.logoH.constant = 52;
            self.logoBtn.layer.cornerRadius = 52.f/2.f;
            self.logoT.constant = 8;
            [self.topImgV setImage:[UIImage imageNamed:@"list_icon_2"]];
            [self.numImgV setImage:[UIImage imageNamed:@"list_icon_medal_2"]];
            bottomBorder.frame = CGRectMake(0, 115-1, ScreenWidth, 0.5f);
        }
            break;
            
        case CCTopContributorTop3:
        {
            [self autoSetDimension:ALDimensionHeight toSize:102];
            self.logoH.constant = 42;
            self.logoBtn.layer.cornerRadius = 42.f/2.f;
            self.logoT.constant = 4;
            [self.topImgV setImage:[UIImage imageNamed:@"list_icon_3"]];
            [self.numImgV setImage:[UIImage imageNamed:@"list_icon_medal_3"]];
            bottomBorder.frame = CGRectMake(0, 102-1, ScreenWidth, 0.5f);
        }
            break;
            
        default:
            break;
    }
}

@end
