//
//  EVAccountBindViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

///EVAccountBindViewController
//

#import "EVViewController.h"

@class EVRelationWith3rdAccoutModel;

@protocol EVAccountBindViewControllerDelegate <NSObject>

@optional

- (void)accoutBindChanged:(EVRelationWith3rdAccoutModel *)model;


@end

@interface EVAccountBindViewController : EVViewController

@property (strong, nonatomic) NSArray *auth;

@property ( weak, nonatomic ) id<EVAccountBindViewControllerDelegate> delegate;


+ (instancetype)instanceWithAuth:(NSArray *)auth;

@end
