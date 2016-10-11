//
//  EVNoDisturbOneTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVFanOrFollowerModel;
@class EVNoDisturbOneTableViewCell;

typedef void(^lookOverOnebodyProfile)(void);
typedef void(^switcherHandler)(BOOL on, EVNoDisturbOneTableViewCell *cell);

@interface EVNoDisturbOneTableViewCell : UITableViewCell

@property (copy, nonatomic) lookOverOnebodyProfile lookOver;
@property (copy, nonatomic) switcherHandler switchHandle;
@property (strong, nonatomic) EVFanOrFollowerModel *model;
@property (assign, nonatomic) BOOL switchEnable; /**< 开关是否可用 */

@end

