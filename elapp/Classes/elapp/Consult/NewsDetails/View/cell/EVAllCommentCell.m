//
//  EVAllCommentCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVAllCommentCell.h"
#import "EVLineView.h"

@implementation EVAllCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _allCommentLabel.text = @"全部评论（0）";
    
    EVLineView *lineView = [EVLineView new];
    [self addSubview:lineView];
    lineView.backgroundColor = CCColor(238, 238, 238);
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
