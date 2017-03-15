//
//  EVEditGlobalViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/30.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"


typedef void(^popBlock)();
@interface EVEditGlobalViewController : EVViewController

@property (nonatomic, copy) NSArray *selectedStocks;
@property (nonatomic, copy) popBlock popBlock;

@end
