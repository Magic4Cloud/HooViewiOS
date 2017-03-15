//
//  EVEditTableViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseTableViewCell.h"
#import "EVStockBaseModel.h"


@class EVEditTableViewCell;
@protocol EVEditTableViewDelegate <NSObject>

- (void)deleteTableCell:(EVEditTableViewCell *)cell model:(EVStockBaseModel *)model;

@end

@interface EVEditTableViewCell : EVBaseTableViewCell

@property (nonatomic, weak) id<EVEditTableViewDelegate> delegate;

@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;

@end
