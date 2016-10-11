//
//  EVAuthSettingTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVAuthSettingModel, EVAuthSettingTableViewCell;

@protocol EVAuthSettingTableViewCellDelegate <NSObject>

- (void)switchWithCell:(EVAuthSettingTableViewCell *)cell isOn:(BOOL)isOn;

@end

@interface EVAuthSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) EVAuthSettingModel *authModel;

@property (strong, nonatomic) NSArray *accounts; 

@property (nonatomic, assign) id<EVAuthSettingTableViewCellDelegate> delegate;

/**
 *  添加seperator
 *
 *  @param position 最上边或者最下边 0：上边 1：下边
 */
- (void)addSeperatorViewWithPosition:(NSInteger)position;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
