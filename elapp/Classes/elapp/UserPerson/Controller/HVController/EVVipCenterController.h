//
//  EVVipCenterController.h
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"
#import "EVUserModel.h"
//static CGFloat const kWMHeaderViewHeight = 200;
static CGFloat const kNavigationBarHeight = 64;

@interface EVVipCenterController : WMPageController
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, strong) EVUserModel *usermodel;




@end
