//
//  EVDanmuView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVDanmuModel.h"

@interface EVDanmuView : UIView

@property (strong, nonatomic) EVDanmuModel * model;

@property (strong, nonatomic) NSLayoutConstraint * leftConstraint;

@property (copy, nonatomic) void(^avatarClick)(EVDanmuModel *model);

@end
