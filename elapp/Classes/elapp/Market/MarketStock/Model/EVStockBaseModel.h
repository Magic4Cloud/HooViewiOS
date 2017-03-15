//
//  EVStockBaseModel.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVStockBaseModel : EVBaseObject

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) float change;
@property (nonatomic, assign) float close;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *low;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *open;
@property (nonatomic, copy) NSString *preclose;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pre_close;
@property (nonatomic, copy) NSString *persent;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) float changepercent;
@property (nonatomic, assign) NSUInteger priority;

@property (nonatomic, assign) BOOL status;

+ (void)getDefaultGlobalArray:(void(^)(NSArray<EVStockBaseModel *> *localStocks, BOOL hasChanged))stockBlock;
+ (void)updateStocksToLocal:(NSArray<EVStockBaseModel *> *)stocks;
+ (void)removeStock:(EVStockBaseModel *)stock;
+ (void)clearStock;

@end
