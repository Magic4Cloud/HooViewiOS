//
//  EVAboutTableViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTableViewController.h"
@class EVUserModel;

@interface EVAboutTableViewController : EVTableViewController

@property (nonatomic,strong) EVUserModel *userModel;

+ (instancetype)instanceFromStoryboard;

@end
