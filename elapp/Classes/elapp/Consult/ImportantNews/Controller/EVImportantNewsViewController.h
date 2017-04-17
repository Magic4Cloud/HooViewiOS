//
//  EVImportantNewsViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"

typedef void(^scrollViewOffsetBlock)(CGFloat scrollViewY,BOOL isStop);

/**
 要闻
 */
@interface EVImportantNewsViewController : EVViewController

@property (nonatomic, strong) UITableView *iNewsTableview;

@property (nonatomic, copy) scrollViewOffsetBlock offsetBlock;

@end
