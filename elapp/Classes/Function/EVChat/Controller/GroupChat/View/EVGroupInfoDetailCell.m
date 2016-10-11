//
//  EVGroupInfoDetailCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupInfoDetailCell.h"
#import <PureLayout.h>
#import "EVGroupInfoModel.h"

@interface EVGroupInfoDetailCell ()

@property (weak , nonatomic) UIImageView *detailMarkImageView;
@property ( weak, nonatomic ) UILabel *rightLabel;


@end

@implementation EVGroupInfoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        // 更多标志图
        UIImageView *detailMarkImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:detailMarkImageView];
        [detailMarkImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [detailMarkImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleLabel];
        detailMarkImageView.image = [UIImage imageNamed:@"personal_find_back"];
        
        // 详情 ..人>
        UILabel *rightLabel = [[UILabel alloc] init];
        self.rightLabel = rightLabel;
        [self.contentView addSubview:rightLabel];
        [rightLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:detailMarkImageView];
        [rightLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:detailMarkImageView];
        rightLabel.font = CCNormalFont(14);
        rightLabel.textColor = [UIColor colorWithHexString:@"#5d5854" alpha:0.6];
    }
    return self;
}

- (void)setCellItem:(EVGroupInfoModel *)cellItem
{
    [super setCellItem:cellItem];
    self.rightLabel.text = cellItem.detailText;
}


@end
