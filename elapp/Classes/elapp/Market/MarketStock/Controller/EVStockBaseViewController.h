//
//  EVStockBaseViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"


/**
 沪深  港股
 */
@interface EVStockBaseViewController : EVViewController

@property (nonatomic, copy) NSString *marketType;

@property (nonatomic, assign) NSInteger chooseIndex;

@end
