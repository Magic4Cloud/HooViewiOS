//
//  EVMarketDetailsController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"
#import "EVStockBaseModel.h"
#import <WebKit/WebKit.h>

@interface EVMarketDetailsController : EVViewController

@property (nonatomic, strong) EVStockBaseModel *stockBaseModel;

@property (nonatomic, assign) NSInteger  special;
@end
