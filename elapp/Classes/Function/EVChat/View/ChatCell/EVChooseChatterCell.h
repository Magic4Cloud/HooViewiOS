//
//  EVChooseChatterCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVNotifyConversationItem;
@class EVUserModel;

@interface EVChooseChatterCell : UITableViewCell

@property ( strong, nonatomic ) EVNotifyConversationItem *cellItem;
@property ( strong, nonatomic ) EVUserModel *userModel;


+ (instancetype) cellForTableView:(UITableView *)tableView;

@end
