//
//  EVEditSelfStockViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"

typedef void(^commitBlock)();

/**
 编辑自选
 */
@interface EVEditSelfStockViewController : EVViewController

@property (nonatomic, copy)commitBlock commitBlock;

@end
