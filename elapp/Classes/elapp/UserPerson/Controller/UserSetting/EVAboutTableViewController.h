//
//  EVAboutTableViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
@class EVUserModel;

@interface EVAboutTableViewController : EVViewController

@property (nonatomic,strong) EVUserModel *userModel;

+ (instancetype)instanceFromStoryboard;

@end
