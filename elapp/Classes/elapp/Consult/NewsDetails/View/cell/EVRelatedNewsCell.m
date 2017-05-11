//
//  EVRelatedNewsCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVRelatedNewsCell.h"
#import "EVLineView.h"

@implementation EVRelatedNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel autoSetDimension:ALDimensionHeight toSize:44];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:26];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:31];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor evTextColorH1];
    titleLabel.font = [UIFont textFontB2];
    
    EVLineView *lineView = [EVLineView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor evLineColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:26];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:29];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];

    
}


-(void)setNewsModel:(EVNewsModel *)newsModel {
    _newsModel = newsModel;
    _titleLabel.text = newsModel.title;
}


@end
