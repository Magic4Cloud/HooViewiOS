//
//  EVNewsTagsCell.m
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNewsTagsCell.h"
#import "EVNewsDetailModel.h"
#import "NSString+Extension.h"

@interface EVNewsTagsCell()
@property (nonatomic, strong) UIButton *firstStockButton;
@property (nonatomic, strong) UIButton *secondStockButton;
@property (nonatomic, strong) NSLayoutConstraint *topHeight;

@end

@implementation EVNewsTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        [self initUI];
    }
    return self;
}


- (void)setTagsModelArray:(NSArray *)tagsModelArray
{
    if (!tagsModelArray) {
        return;
    }
    _tagsModelArray = tagsModelArray;
//    for (EVTagModel * model in tagsModelArray) {
//        SKTag *tag = [SKTag tagWithText:model.name];
//        tag.textColor = [UIColor evTextColorH1];
//        tag.fontSize = 14;
//        tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
//        tag.bgImg = [UIImage imageWithColor:CCColor(248, 248, 248)];
//        tag.cornerRadius = 5;
//        tag.enable = NO;
//        [self.cellTagView addTag:tag];
//    }
//    _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
//    if (self.tagCellHeight) {
//        self.tagCellHeight(_cellHeight);
//    }
    
    CGFloat x = 16;
    CGFloat y = 17;
    
    // 屏幕的宽度 和 内容左右的边距
    CGFloat maxX = ScreenWidth - 32;
    CGFloat lastHeight = 0.f;
    UIFont *font = [UIFont textFontB3];
    
    int i = 0;
    
    for (EVTagModel * model in tagsModelArray) {
        NSString *obj = [NSString string];
        obj = [NSString stringWithFormat:@" %@ ",model.name];
        CGRect rect = [obj xh_computeOfTextRectByFont:font maxSize:CGSizeMake(maxX + 1, 1000)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, floor(rect.size.width) + 4, floor(rect.size.height) + 4)];
        label.text = obj;
        label.font = [UIFont textFontB3];
        label.textColor = [UIColor blackColor];
        
        label.layer.cornerRadius = 2;
        label.backgroundColor = CCColor(248, 248, 248);
        label.layer.borderWidth = 1;
        label.layer.borderColor = CCColor(238, 238, 238).CGColor;
        
        [self addSubview:label];
        
        if (rect.size.width > maxX) {
            // +16 为添加上下边距
            x = 16;
            label.frame = CGRectMake(x, y + lastHeight, floor(rect.size.width) + 4, floor(rect.size.height) + 4);
            y += lastHeight;
            lastHeight = rect.size.height + 16;
        } else if (rect.size.width + x - 16 > maxX) {
            // -16 去掉左边距
            x = 16;
            label.frame = CGRectMake(x, y + lastHeight, floor(rect.size.width) + 4, floor(rect.size.height) + 4);
            y += lastHeight;
            lastHeight = rect.size.height + 16;
        }
        
        if (lastHeight == 0) {
            lastHeight = rect.size.height + 16;
        }
        
        // +8 添加左右间距
        x =  x + rect.size.width + 16;
        i ++;
    }
    
    _cellHeight = y + 25;
    if (self.tagCellHeightBlock) {
        NSLog(@"1111");
        self.tagCellHeightBlock(_cellHeight);
    }
}


- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _cellTagView = [[SKTagView alloc] init];
    [self.contentView addSubview:_cellTagView];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_cellTagView autoSetDimension:ALDimensionHeight toSize:22];
}

@end
