//
//  EVAccountPhoneBindViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
#import "EVRelationWith3rdAccoutModel.h"

@interface EVAccountPhoneBindViewController : EVViewController

+ (instancetype)accountPhoneBindViewController;
@property (strong, nonatomic) EVRelationWith3rdAccoutModel *model;

@end
