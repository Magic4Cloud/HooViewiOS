//
//  EVCircleLiveVideoTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVCircleRecordedModel;

@interface EVCircleLiveVideoTableViewCell : UITableViewCell

@property ( strong, nonatomic ) EVCircleRecordedModel *cellItem;
@property (copy, nonatomic) void(^avatarClick)(EVCircleRecordedModel *model);  /**< 头像点击 */

+ (NSString *)cellIdentifier;

+ (CGFloat)cellHeight;

+ (instancetype) cellForTableView:(UITableView *) tableView;

@end
