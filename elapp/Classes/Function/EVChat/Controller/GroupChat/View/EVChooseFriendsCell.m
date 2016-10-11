//
//  EVChooseFriendsCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChooseFriendsCell.h"
#import "EVHeaderView.h"
#import "EVNickNameAndLevelView.h"
#import <PureLayout.h>
#import "EVFriendItem.h"

#define CCChooseFriendsCellID @"CCChooseFriendsCellID"

@interface EVChooseFriendsCell ()

@property ( weak, nonatomic ) UIButton *markButton;
@property ( weak, nonatomic ) CCHeaderImageView *headerImageView;
@property ( weak, nonatomic ) UILabel *nicknameLabel;
@property ( weak, nonatomic ) EVNickNameAndLevelView *levelView;


@end

@implementation EVChooseFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubviews];
    }
    return self;
}

+ (NSString *)cellID
{
    return CCChooseFriendsCellID;
}

- (void)createSubviews
{
    // 标记
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:markButton];
    [markButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [markButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [markButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    self.markButton = markButton;
    [markButton setImage:[UIImage imageNamed:@"select_new"] forState:UIControlStateSelected];
    [markButton setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    [markButton setImage:[UIImage imageNamed:@"select_old"] forState:UIControlStateDisabled];
    [markButton addTarget:self action:@selector(clickMarkButton:) forControlEvents:UIControlEventTouchUpInside];
    // 头像
    CCHeaderImageView *headerImageView = [[CCHeaderImageView alloc] init];
    [self.contentView addSubview:headerImageView];
    [headerImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:markButton withOffset:10.f];
    [headerImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [headerImageView autoSetDimensionsToSize:CGSizeMake(45, 45)];
    self.headerImageView = headerImageView;
    
    // 昵称
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nicknameLabel];
    [nicknameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headerImageView withOffset:4.f];
    [nicknameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.nicknameLabel = nicknameLabel;
    nicknameLabel.textColor = CCTextBlackColor;
    nicknameLabel.font = CCNormalFont(14);
    [nicknameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [nicknameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    // 等级
    EVNickNameAndLevelView *levelView = [[EVNickNameAndLevelView alloc] init];
    [self.contentView addSubview:levelView];
    [levelView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:nicknameLabel withOffset:4.f];
    [levelView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.f relation:NSLayoutRelationGreaterThanOrEqual];
    [levelView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.levelView = levelView;
}

- (void)setCellItem:(EVFriendItem *)cellItem
{
    _cellItem = cellItem;
    self.markButton.selected = cellItem.selected;
    [self.headerImageView cc_setImageWithURLString:cellItem.logourl isVip:cellItem.vip vipSizeType:CCVipMiddle];
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@",cellItem.nickname];
    self.levelView.gender = cellItem.gender;
//    CCLog(@"####-----%d,----%s-----%zd---####",__LINE__,__FUNCTION__,cellItem.disable);

    self.markButton.enabled = !cellItem.disable;
}

- (void)clickMarkButton:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chooseCell:didSelected:)] )
    {
        [self.delegate chooseCell:self didSelected:button];
    }
}


@end
