//
//  EVChooseChatterCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChooseChatterCell.h"
#import "EVHeaderView.h"
#import <PureLayout.h>
#import "EVNotifyConversationItem.h"
#import "EVUserModel.h"

@interface EVChooseChatterCell ()

@property ( weak, nonatomic ) CCHeaderImageView *iconImageView;
@property ( weak, nonatomic ) UILabel *nameLabel;
@property ( weak, nonatomic ) UILabel *signalLabel;

@end

@implementation EVChooseChatterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    CCHeaderImageView *iconImageView = [[CCHeaderImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [_iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15];
    [_iconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_iconImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImageView withOffset:15];
    [nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    
    UILabel *signalLabel = [[UILabel alloc] init];
    [self.contentView addSubview:signalLabel];
    self.signalLabel = signalLabel;
    [signalLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:21];
    [signalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nameLabel];
    signalLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    signalLabel.font = [UIFont systemFontOfSize:12];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    lineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];

}

- (void)setCellItem:(EVNotifyConversationItem *)cellItem
{
    _cellItem = cellItem;
    [self.iconImageView cc_setImageWithURLString:cellItem.icon placeholderImageName:@"avatar"];
    [self.nameLabel setText:cellItem.title];
    [self.signalLabel setText:cellItem.userModel.signature];
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    [self.iconImageView cc_setImageWithURLString:userModel.logourl placeholderImageName:nil];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@",userModel.nickname]];
    [self.signalLabel setText:userModel.signature];
}

+ (instancetype) cellForTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"cell";
    EVChooseChatterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil )
    {
        cell = [[EVChooseChatterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end
