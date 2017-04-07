//
//  EVStockBaseViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseTableViewCell.h"
#import "EVStockBaseModel.h"
#import "EVTodayFloatModel.h"
#import "EVStockBaseModel.h"

typedef NS_ENUM(NSUInteger, EVStockBaseViewCellType) {
    EVStockBaseViewCellTypeSock,
    EVStockBaseViewCellTypeSelfSock,
    EVStockBaseViewCellTypeGlobalSock,
    
};

@interface EVStockBaseViewCell : UITableViewCell
@property (nonatomic, strong) UIColor *rankColor;
@property (nonatomic, weak) UILabel *rankLabel;
@property (nonatomic, weak) UILabel *lineLabel;


@property (nonatomic, strong) EVTodayFloatModel *stockBaseModel;

@property (nonatomic, assign) EVStockBaseViewCellType cellType;

@property (nonatomic, strong) EVStockBaseModel *upStockBaseModel;

@property (nonatomic, strong) EVStockBaseModel *searchBaseModel;

@property (nonatomic, strong) EVStockBaseModel *globalBaseModel;

@end
