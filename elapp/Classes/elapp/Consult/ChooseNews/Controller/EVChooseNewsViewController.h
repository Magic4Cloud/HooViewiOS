//
//  EVChooseNewsViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVViewController.h"



typedef void(^scrollViewOffsetBlock)(CGFloat scrollViewY,BOOL isStop);
@interface EVChooseNewsViewController : EVViewController
@property (nonatomic, copy) scrollViewOffsetBlock offsetBlock;
@property (nonatomic, weak) UITableView *newsTableView;
@end
