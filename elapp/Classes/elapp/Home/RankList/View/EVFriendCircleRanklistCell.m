//
//  EVFriendCircleRanklistCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFriendCircleRanklistCell.h"
#import <PureLayout.h>
#import "UIImageView+WebCache.h"
#import "EVNickNameAndLevelView.h"


@interface  EVFriendCircleRanklistCell ()

@property (nonatomic, weak) UIImageView *avatarImg;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *infoLabel;
@property ( nonatomic, weak ) EVNickNameAndLevelView *levelView;// 昵称和等级

@end

@implementation EVFriendCircleRanklistCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews
{
    CGFloat leftMargin = 17.5f;
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIImageView *ranklistImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_one"]];
    ranklistImg.hidden = YES;
    [bgView addSubview:ranklistImg];
    ranklistImg.backgroundColor = [UIColor clearColor];
    ranklistImg.image = [UIImage imageNamed:@"home_leaderboard_pic_rankingone"];
    [ranklistImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:leftMargin];
    [ranklistImg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.ranklistImg = ranklistImg;
    
    UILabel *ranklistLabel = [[UILabel alloc] init];
    ranklistLabel.text = @"4";
    ranklistLabel.hidden = YES;
    ranklistLabel.font = [UIFont systemFontOfSize:16.f];
    ranklistLabel.textColor = [UIColor colorWithHexString:@"#5d5854"];
    [bgView addSubview:ranklistLabel];
    ranklistLabel.backgroundColor = [UIColor clearColor];
    ranklistLabel.textAlignment = NSTextAlignmentCenter;
    [ranklistLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:ranklistImg];
    [ranklistLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:ranklistImg];
    [ranklistLabel autoSetDimensionsToSize:ranklistImg.image.size];
    self.ranklistLabel = ranklistLabel;

    UIImageView *avatarImg = [[UIImageView alloc] init];
    avatarImg.image = [UIImage imageNamed:@"avatar"];
    [bgView addSubview:avatarImg];
    [avatarImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:55.f];
    [avatarImg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [avatarImg autoSetDimensionsToSize:CGSizeMake(42.f, 42.f)];
    avatarImg.layer.masksToBounds = YES;
    avatarImg.layer.cornerRadius = avatarImg.bounds.size.width * 0.5f;
    self.avatarImg = avatarImg;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"王土豪";
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:15.f];
    nameLabel.textColor = [UIColor evTextColorH1];
    [bgView addSubview:nameLabel];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:107];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [nameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    self.nameLabel = nameLabel;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.font = [UIFont systemFontOfSize:13.f];
    infoLabel.textColor = [UIColor evTextColorH2];
    infoLabel.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:infoLabel];
    [infoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:avatarImg];
    [infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImg withOffset:10.f];
    infoLabel.numberOfLines = 1;
    infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.infoLabel = infoLabel;
    
    //等级vip
    EVNickNameAndLevelView *levelView = [[EVNickNameAndLevelView alloc] init];
    [bgView addSubview:levelView];
    [levelView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nameLabel];
    [levelView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:nameLabel withOffset:0.f];
    [levelView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-3 relation:NSLayoutRelationGreaterThanOrEqual];
    _levelView = levelView;
    
    
    UILabel *dividingLine = [[UILabel alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [bgView addSubview:dividingLine];
    [dividingLine autoSetDimension:ALDimensionHeight toSize:1.f];
    [dividingLine autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 55.f];
    [dividingLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView];
    [dividingLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView];
    self.dividingLine = dividingLine;
}

-(void)setSendModel:(CCFriendCircleRanklistSendModel *)sendModel
{
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:sendModel.logourl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.cornerRadius = 21.f;
    self.nameLabel.text = sendModel.nickname;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@",kE_GlobalZH(@"send_ecoin"),sendModel.costecoin];
    self.levelView.gender = sendModel.gender;
    self.levelView.birth = sendModel.birthday;
    self.levelView.levelModeType = EVLevelModeTypeNmBack;
}

-(void)setReceiveModel:(CCFriendCircleRanklistReceiveModel *)receiveModel
{
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:receiveModel.logourl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.cornerRadius = 21.f;
    self.nameLabel.text = receiveModel.nickname;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@",kE_GlobalZH(@"receiveTicket"),receiveModel.riceroll];
    self.levelView.gender = receiveModel.gender;
    self.levelView.birth = receiveModel.birthday;
}

@end
