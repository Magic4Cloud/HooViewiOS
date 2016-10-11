//
//  EVMngUserListController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"


@protocol MngUserListDelegate <NSObject>

- (void)mngUserListArray:(NSMutableArray *)array;

@end
@interface EVMngUserListController : EVViewController
@property (nonatomic,strong)NSString *vid;//主播云播号
@property (nonatomic,assign) id<MngUserListDelegate> delegate;
@end
