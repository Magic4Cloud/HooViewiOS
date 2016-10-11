//
//  EVGroupInfoIconCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVGroupInfoIconCell.h"
#import "EVHeaderView.h"
#import <PureLayout.h>
#import "EVGroupInfoModel.h"

@interface EVGroupInfoIconCell ()

@property (weak,nonatomic)CCHeaderImageView *headerImageView;

@end

@implementation EVGroupInfoIconCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        // 头像
        CCHeaderImageView *headerImageView = [[CCHeaderImageView alloc] init];
        [self.contentView addSubview:headerImageView];
        [headerImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLabel withOffset:20.f];
        [headerImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [headerImageView autoSetDimensionsToSize:CGSizeMake(40, 40)];
        self.headerImageView = headerImageView;
    }
    return self;
}

- (void)setCellItem:(EVGroupInfoModel *)cellItem
{
    [super setCellItem:cellItem];
    [self.headerImageView cc_setImageWithURLString:cellItem.icon isVip:cellItem.vip vipSizeType:CCVipMini];
}


@end
