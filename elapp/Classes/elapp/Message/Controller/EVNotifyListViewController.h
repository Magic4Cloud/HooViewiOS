//
//  EVNotifyListViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVViewController.h"
@class EVNotifyItem;

typedef void(^readMessageBlock)(BOOL isRead);

/**
 消息中心
 */
@interface EVNotifyListViewController : EVViewController

@property (nonatomic, copy) readMessageBlock messageBlock;

@property (nonatomic,strong) EVNotifyItem *notiItem;

@end
