//
//  EVTodayFloatModel.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/22.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVStockBaseModel.h"

@interface EVTodayFloatModel : EVStockBaseModel


@property (nonatomic, assign) float changepercent;
@property (nonatomic, copy) NSString *turnoverratio;
@property (nonatomic, copy) NSString *per;//市盈率
@property (nonatomic, copy) NSString *pb; //市净率
@property (nonatomic, copy) NSString *mktcap;//总市值
@property (nonatomic, copy) NSString *nmc;//流通市值

@end
