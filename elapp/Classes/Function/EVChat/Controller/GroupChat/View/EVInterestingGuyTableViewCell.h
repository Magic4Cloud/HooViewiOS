//
//  EVInterestingGuyTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVFanOrFollowerModel;

@interface EVInterestingGuyTableViewCell : UITableViewCell

@property (strong, nonatomic) EVFanOrFollowerModel *model;
@property (copy, nonatomic) void(^avatarClickBlock)(EVFanOrFollowerModel *model);
@property (weak, nonatomic) UIButton *changeStateBtn;

+ (NSString *)cellID;

@end
