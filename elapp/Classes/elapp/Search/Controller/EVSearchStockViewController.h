//
//  EVSearchStockViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVViewController.h"

/**
 搜索界面
 */
@interface EVSearchStockViewController : EVViewController

/**
 添加自选回调block
 */
@property (nonatomic, copy) void(^addStockBlock)(NSString *symbol);

@end
