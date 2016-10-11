//
//  EVNotifyViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVNotifyItem.h"
#import "RKNotificationHub.h"
#import "EVGroupItem.h"

@interface EVNotifyViewCell : UITableViewCell

+ (instancetype)notifyViewCell;

/**存放所有消息的模型*/
@property (nonatomic, strong) EVNotifyItem *cellItem;
@property (nonatomic, strong) UIFont *contantLabelFont;

@property ( strong, nonatomic ) EVGroupItem *groupItem;
/**cell返回高度*/
- (CGFloat)cellHeight;

@property (nonatomic, strong) RKNotificationHub* hub;

@end
