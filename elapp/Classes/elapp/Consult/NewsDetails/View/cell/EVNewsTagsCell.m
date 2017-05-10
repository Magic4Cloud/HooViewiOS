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
//        tag.bgImg = [UIImage imageWithColor:[UIColor redColor]];
        tag.cornerRadius = 5;
        tag.enable = NO;
        [self.cellTagView addTag:tag];
    }
    _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
    if (self.tagCellHeight) {
        self.tagCellHeight(_cellHeight);
    }

}


//-(void)setStockModelArray:(NSArray *)stockModelArray {
//    if (!stockModelArray) {
//        _topHeight.constant = 0;
//        _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
//        if (self.tagCellHeight) {
//            self.tagCellHeight(_cellHeight);
//        }
//        return;
//    }
//    _stockModelArray = stockModelArray;
//    
//    EVStockModel * firtsModel = stockModelArray[0];
//    EVStockModel * secondModel = stockModelArray[1];
//    
//    [_firstStockButton setTitle:[NSString stringWithFormat:@" %@ %@%% ",firtsModel.name,firtsModel.persent] forState:UIControlStateNormal];
//    [_secondStockButton setTitle:[NSString stringWithFormat:@" %@ %@%% ",secondModel.name,secondModel.persent] forState:UIControlStateNormal];
//    _firstStockButton.backgroundColor = [firtsModel.persent floatValue] > 0 ? [UIColor redColor] : [UIColor blueColor];
//    _secondStockButton.backgroundColor = [secondModel.persent floatValue] > 0 ? [UIColor redColor] : [UIColor blueColor];
//    
//    if (stockModelArray.count == 0) {
//        _topHeight.constant = 0;
//        _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
//    } else {
//        _topHeight.constant = 55;
//        _cellHeight = [self.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
//        if (stockModelArray.count == 1) {
//            _firstStockButton.hidden = NO;
//            _secondStockButton.hidden = YES;
//        } else {
//            _firstStockButton.hidden = NO;
//            _secondStockButton.hidden = NO;
//        }
//    }
//    
//    if (self.tagCellHeight) {
//        self.tagCellHeight(_cellHeight);
//    }
//
//}



- (void)initUI
{
    
//    _firstStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:_firstStockButton];
//    _firstStockButton.layer.cornerRadius = 2;
//    [_firstStockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _firstStockButton.titleLabel.font = [UIFont textFontB3];
//    [_firstStockButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
//    [_firstStockButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
//    [_firstStockButton autoSetDimension:ALDimensionHeight toSize:22];
//    
//    
//    _secondStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:_secondStockButton];
//    _secondStockButton.layer.cornerRadius = 2;
//    [_secondStockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _secondStockButton.titleLabel.font = [UIFont textFontB3];
//    [_secondStockButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
//    [_secondStockButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_firstStockButton withOffset:16];
//    [_secondStockButton autoSetDimension:ALDimensionHeight toSize:22];
    
    
    _cellTagView = [[SKTagView alloc] init];
    [self.contentView addSubview:_cellTagView];
    _topHeight = [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_cellTagView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
}

@end
