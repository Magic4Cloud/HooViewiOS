//
//  EVLimitSearchCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVLimitSearchCell, EVFriendItem;

@protocol CCLimitSearchCellDelegate <NSObject>

@optional
- (void)limitCellDidBeginEdit:(EVLimitSearchCell *)cell;
- (void)limitCell:(EVLimitSearchCell *)cell textChange:(NSString *)text;
- (void)limitCellDeleteLastItem:(EVLimitSearchCell *)cell;
- (void)limitCellDidCancelItem:(EVFriendItem *)item;

@end

@interface EVLimitSearchCell : UITableViewCell

@property (nonatomic,weak) id<CCLimitSearchCellDelegate> delegate;

@property (copy, nonatomic) NSString *placeHolder;  /**< 占位文字 */

+ (NSString *)cellID;

- (void)selectFriendItem:(EVFriendItem *)item;
- (void)deSelectFriendItem:(EVFriendItem *)item;

- (void)beignEditing;
- (void)endEditing;

@end
