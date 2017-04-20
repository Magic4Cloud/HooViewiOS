//
//  EVFansOrFocusTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EVEnums.h"
@class EVFanOrFollowerModel;

typedef void(^ICONCLICK)(EVFanOrFollowerModel *model);

@interface EVFansOrFocusTableViewCell : UITableViewCell

@property (assign, nonatomic) controllerType type;
@property (strong, nonatomic) EVFanOrFollowerModel *model;

@property (copy, nonatomic) ICONCLICK iconClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introTrailing;

@end
