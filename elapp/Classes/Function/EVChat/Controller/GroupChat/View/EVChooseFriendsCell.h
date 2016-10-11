//
//  EVChooseFriendsCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@class EVFriendItem;
@class EVChooseFriendsCell;

@protocol EVChooseFriendsCellDelegate <NSObject>

- (void)chooseCell:(EVChooseFriendsCell *)cell didSelected:(UIButton *)button;

@end

@interface EVChooseFriendsCell : UITableViewCell

@property ( strong, nonatomic ) EVFriendItem *cellItem;
@property ( weak, nonatomic ) id<EVChooseFriendsCellDelegate> delegate;


+ (NSString *)cellID;

@end
