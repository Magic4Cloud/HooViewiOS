//
//  EVMarketViewController.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVHomeScrollViewController.h"
#import "WMPageController.h"

/**
 行情
 */
static CGFloat const kWMHeaderViewHeight = 0;
static CGFloat const kNavigationBarHeight = 64;
@interface EVMarketViewController : WMPageController
@property (nonatomic, assign) CGFloat viewTop;

@end
