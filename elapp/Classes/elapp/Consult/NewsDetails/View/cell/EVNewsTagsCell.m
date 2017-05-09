//
//  EVNewsTagsCell.m
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsTagsCell.h"
#import "EVNewsDetailModel.h"
#import "UIImage+Extension.h"
@implementation EVNewsTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}

- (void)setTagsModelArray:(NSArray *)tagsModelArray
{
    if (!tagsModelArray) {
        return;
    }
    _tagsModelArray = tagsModelArray;
    for (EVTagModel * model in tagsModelArray) {
        SKTag *tag = [SKTag tagWithText:model.name];
        tag.textColor = [UIColor whiteColor];
        tag.fontSize = 15;
        tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
        tag.bgImg = [UIImage imageWithColor:[UIColor redColor]];
        tag.cornerRadius = 5;
        tag.enable = NO;
        [self.cellTagView addTag:tag];
    }
    _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
}

- (void)initUI
{
    _cellTagView = [[SKTagView alloc] init];
    [self.contentView addSubview:_cellTagView];
    [_cellTagView autoPinEdgesToSuperviewEdges];
}

@end
