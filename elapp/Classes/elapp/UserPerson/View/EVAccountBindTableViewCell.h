//
//  EVAccountBindTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVRelationWith3rdAccoutModel;

extern NSString *const QQTYPE;
extern NSString *const PHONETYPE;
extern NSString *const WEIXINTYPE;
extern NSString *const WEIBOTYPE;

@interface EVAccountBindTableViewCell : UITableViewCell

@property (strong, nonatomic) EVRelationWith3rdAccoutModel *model;
@property (copy, nonatomic) void(^bindBlock)(NSString *type);
@property (copy, nonatomic) void(^undoBindBlock)(NSString *type);
@property (assign, nonatomic) BOOL canShowBindButton;

@end
