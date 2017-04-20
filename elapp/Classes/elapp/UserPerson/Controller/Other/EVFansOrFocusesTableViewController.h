//
//  EVFansOrFocusesTableViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTableViewController.h"
#include "EVEnums.h"

@interface EVFansOrFocusesTableViewController : EVTableViewController

@property (assign, nonatomic) controllerType type;
@property (assign, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL navitionHidden;

@end
