//
//  EVLimitViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveViewController.h"
#import "EVTableViewController.h"

@protocol EVLimitViewControllerDelegate <NSObject>

@optional
- (void)limitViewControllerDidComfirmWithPermission:(EVLivePermission)permission params:(NSDictionary *)params;

@end

@interface EVLimitViewController : UIViewController

/** 用来标记该控制器是否重用的 */
@property (nonatomic, assign) BOOL reuse;

@property (nonatomic,weak) id<EVLimitViewControllerDelegate> delegate;

@end
