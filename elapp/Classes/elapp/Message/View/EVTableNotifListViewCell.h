//
//  EVTableNotifListViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVNotifyList;
@class EVTableNotifListViewCell;


@interface EVTableNotifListViewCell : UITableViewCell

/**所有的消息模型*/
@property (nonatomic, strong) EVNotifyList *cellItem;
/**消息头像url*/
@property (nonatomic, copy) NSString *iconURL;
/**返回cell的高度*/
+ (CGFloat)cellHeightForCellItem:(EVNotifyList *)cellItem;

@end
