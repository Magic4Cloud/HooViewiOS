//
//  EVStockBaseModel.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockBaseModel.h"

static NSString * const kDidModifyStock = @"kDidModifyStock";

@implementation EVStockBaseModel

#pragma mark - public methods
+ (void)getDefaultGlobalArray:(void(^)(NSArray<EVStockBaseModel *> *localStocks, BOOL hasChanged))stockBlock {
    EVQueryObject *query = [EVQueryObject new];
    query.clazz = [self class];
    query.tailSql = @"ORDER BY priority DESC";
    [self queryWithQueryObj:(CCQueryObject *)query complete:^(NSArray *stocks) {
        if (stocks && stocks.count > 0) {
            !stockBlock ? : stockBlock(stocks, YES);
        }
        else {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kDidModifyStock]) {
                !stockBlock ? : stockBlock(@[], YES);
                return ;
            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidModifyStock];
            // 默认的九个指数
            NSArray<NSString *> *defaultSymbols = @[@"IXIXDJIA",
                                                    @"IXIXNDX",
                                                    @"IXIXIXY",
                                                    @"IXIXKS11",
                                                    @"IXIXNI225",
                                                    @"IXIXFTSE",
                                                    @"IXIXAORD",
                                                    @"IXIXGDAXI",
                                                    @"IXIXFCHI"];
            
            NSMutableArray *tempArray = @[].mutableCopy;
            [defaultSymbols enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVStockBaseModel *model = [EVStockBaseModel new];
                model.priority = idx;
                model.symbol = obj;
                [tempArray addObject:model];
            }];
            
            [self updateStocksToLocal:tempArray];
            
            !stockBlock ? : stockBlock(tempArray.copy, NO);
        }
    }];
}

+ (void)updateStocksToLocal:(NSArray<EVStockBaseModel *> *)stocks {
    if (!stocks || stocks.count == 0) {
        return;
    }
    [stocks enumerateObjectsUsingBlock:^(EVStockBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateToLocalCacheComplete:nil];
    }] ;
}

+ (void)removeStock:(EVStockBaseModel *)stock {
    if (!stock) {
        return;
    }
    [stock deleteFromLocalCacheComplete:nil];
}

+ (void)clearStock {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDidModifyStock];
    [self cleanTable];
}

#pragma mark - private methods

+ (NSString *)keyColumn {
    return @"symbol";
}

+ (NSString *)keyColumnType {
    return COLUMN_TYPE_STRING;
}

+ (NSInteger)tableVersion {
    return 1;
}

@end
