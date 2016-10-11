//
//  EVRedEnvelopeCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVRedEnvelopeCell.h"
#import <PureLayout.h>
#import "UIImageView+WebCache.h"

@interface EVRedEnvelopeCell ()

@property (nonatomic, weak) UIImageView *avatarImg;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *bestLuck;
@property (nonatomic, weak) UILabel *detailLabel;

@end

#define AvatarWidth 42.f

@implementation EVRedEnvelopeCell

- (void)dealloc
{
    
}

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
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    UIImageView *avatarImg = [[UIImageView alloc] init];
    avatarImg.image = [UIImage imageNamed:@"avatar"];
    [bgView addSubview:avatarImg];
    [avatarImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:10.f];
    [avatarImg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [avatarImg autoSetDimensionsToSize:CGSizeMake(AvatarWidth, AvatarWidth)];
    avatarImg.layer.masksToBounds = YES;
    avatarImg.clipsToBounds = YES;
    avatarImg.layer.cornerRadius = AvatarWidth * 0.5f;
    self.avatarImg = avatarImg;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#5d5854"];
    [bgView addSubview:nameLabel];
    [nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:avatarImg withOffset:10.f];
    self.nameLabel = nameLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:12.f];
    detailLabel.textColor = [UIColor colorWithHexString:@"#5d5854"];
    [bgView addSubview:detailLabel];
    [detailLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [detailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-10.f];
    self.detailLabel = detailLabel;
    
    UIButton *bestLuck = [[UIButton alloc]init];
    [bestLuck setTitle:kE_GlobalZH(@"best_luck") forState:UIControlStateNormal];
    bestLuck.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [bestLuck setTitleColor:[UIColor colorWithHexString:@"#F7D80B"] forState:UIControlStateNormal];
    [bestLuck setImage:[UIImage imageNamed:@"living_redpaper_luck"] forState:UIControlStateNormal];
    [bgView addSubview:bestLuck];
    bestLuck.hidden = YES;
    [bestLuck autoSetDimensionsToSize:CGSizeMake(60, 11)];
    [bestLuck autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:detailLabel];
    [bestLuck autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailLabel withOffset:5.f];
    self.bestLuck = bestLuck;
    
    UILabel *dividingLine = [[UILabel alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [bgView addSubview:dividingLine];
    [dividingLine autoSetDimension:ALDimensionHeight toSize:.5f];
    [dividingLine autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [dividingLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
    [dividingLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:_itemModel.logoUrl] placeholderImage:nil completed:nil];
    _avatarImg.layer.masksToBounds = YES;
    _avatarImg.clipsToBounds = YES;
    _avatarImg.layer.cornerRadius = AvatarWidth * 0.5;
}

- (void)setItemModel:(EVRedEnvelopeItemModel *)itemModel
{
    _itemModel = itemModel;
    _nameLabel.text = itemModel.nickname;
    _detailLabel.text = [NSString stringWithFormat:@"%d %@", [itemModel.ecoin intValue],kE_Coin];
    
    if ( [itemModel.isbest boolValue] == 1 )
    {
        _bestLuck.hidden = NO;
    }
    else
    {
       _bestLuck.hidden = YES;
    }
}

@end
