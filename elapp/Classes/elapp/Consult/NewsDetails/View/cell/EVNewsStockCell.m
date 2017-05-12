//
//  EVNewsStockCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsStockCell.h"
#import "EVNewsDetailModel.h"
#import "UIImage+Extension.h"
#import "EVMarketDetailsController.h"


@interface EVNewsStockCell()
@property (nonatomic, strong) UIButton *firstStockButton;
@property (nonatomic, strong) UIButton *secondStockButton;

@end

@implementation EVNewsStockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}

-(void)setStockModelArray:(NSArray *)stockModelArray {
    if (!stockModelArray) {
        return;
    }
    _stockModelArray = stockModelArray;
    
    if (stockModelArray.count == 1) {
        EVStockModel * firtsModel = stockModelArray[0];
        [_firstStockButton setTitle:[NSString stringWithFormat:@" %@ %@%% ",firtsModel.name,firtsModel.persent] forState:UIControlStateNormal];
        
        _firstStockButton.backgroundColor = [firtsModel.persent floatValue] > 0 ? CCColor(255, 72, 74) : CCColor(65, 212, 174);
    }
    
    if (stockModelArray.count > 1) {
        EVStockModel * secondModel = stockModelArray[1];
        [_secondStockButton setTitle:[NSString stringWithFormat:@" %@ %@%% ",secondModel.name,secondModel.persent] forState:UIControlStateNormal];
        _secondStockButton.backgroundColor = [secondModel.persent floatValue] > 0 ? CCColor(255, 72, 74) : CCColor(65, 212, 174);
    }
    
    if (stockModelArray.count == 1) {
        _firstStockButton.hidden = NO;
        _secondStockButton.hidden = YES;
    } else {
        _firstStockButton.hidden = NO;
        _secondStockButton.hidden = NO;
    }
}



- (void)initUI
{
    _firstStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_firstStockButton];
    _firstStockButton.layer.cornerRadius = 2;
    [_firstStockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _firstStockButton.titleLabel.font = [UIFont textFontB3];
    [_firstStockButton addTarget:self action:@selector(action_toFirstStock:) forControlEvents:UIControlEventTouchUpInside];
    [_firstStockButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [_firstStockButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_firstStockButton autoSetDimension:ALDimensionHeight toSize:22];
    [_firstStockButton autoSetDimension:ALDimensionWidth toSize:120];
    
    
    _secondStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_secondStockButton];
    _secondStockButton.layer.cornerRadius = 2;
    [_secondStockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _secondStockButton.titleLabel.font = [UIFont textFontB3];
    [_firstStockButton addTarget:self action:@selector(action_toSecondStock:) forControlEvents:UIControlEventTouchUpInside];
    [_secondStockButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [_secondStockButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_firstStockButton withOffset:16];
    [_secondStockButton autoSetDimension:ALDimensionHeight toSize:22];
    [_firstStockButton autoSetDimension:ALDimensionWidth toSize:120];
}

- (void)action_toFirstStock:(UIButton *)sender {
    EVStockModel *model = _stockModelArray[0];
    EVStockBaseModel * firtsModel = [[EVStockBaseModel alloc] init];
    firtsModel.symbol = model.code;
    firtsModel.name = model.name;
    EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
    marketDetailVC.stockBaseModel = firtsModel;
    if ([firtsModel.symbol isEqualToString:@""] || firtsModel.symbol == nil) {
        return;
    }
    [[self viewController].navigationController pushViewController:marketDetailVC animated:YES];
}

- (void)action_toSecondStock:(UIButton *)sender {
    if (_stockModelArray.count > 1) {
        EVStockModel *model = _stockModelArray[1];
        EVStockBaseModel * secondModel = [[EVStockBaseModel alloc] init];
        secondModel.symbol = model.code;
        secondModel.name = model.name;
        EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
        marketDetailVC.stockBaseModel = secondModel;
        if ([secondModel.symbol isEqualToString:@""] || secondModel.symbol == nil) {
            return;
        }
        [[self viewController].navigationController pushViewController:marketDetailVC animated:YES];
    }
}



- (UIViewController*)viewController {
    for (UIView* next = [self superview];
         next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
