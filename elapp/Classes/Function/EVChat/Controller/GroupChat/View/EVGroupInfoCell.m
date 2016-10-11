//
//  EVGroupInfoCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupInfoCell.h"
#import <PureLayout.h>
#import "EVGroupInfoModel.h"

@interface EVGroupInfoCell ()

@end


@implementation EVGroupInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15];
    self.titleLabelHorizontal = [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    titleLabel.font = CCNormalFont(15);
    titleLabel.textColor = CCTextBlackColor;
    
    // 信息
    UILabel *infoLabel = [[UILabel alloc] init];
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    [infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLabel withOffset:20];
    [infoLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [infoLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50.f relation:NSLayoutRelationGreaterThanOrEqual];
    infoLabel.numberOfLines = 1;
    infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    infoLabel.font = CCNormalFont(15);
    infoLabel.textColor = [UIColor colorWithHexString:@"#5d5854" alpha:0.6];
    
}

- (void)setCellItem:(EVGroupInfoModel *)cellItem
{
    _cellItem = cellItem;
    self.titleLabel.text = cellItem.title;
    self.infoLabel.text = cellItem.infoText;
}

+ ( instancetype )cellForTabelView:(UITableView *)tableView clazz:(NSString *)clazz
{
    static NSString *cellIndentifier = @"cell";
    EVGroupInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if ( infoCell == nil )
    {
        infoCell = [[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return infoCell;
}

@end
