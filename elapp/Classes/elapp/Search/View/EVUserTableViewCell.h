//
//  EVUserTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVFindUserInfo.h"

@interface EVUserTableViewCell : UITableViewCell

/**
 *  @param tableview
 *
 *  @return 返回可重用的Cell
 */
+ (instancetype)userTableViewCellWithTableView:(UITableView *)tableview;

/**
 *  获取cell的可重用标识符
 *
 *  @return cell重用标识符字符串
 */
+ (NSString *)cellID;

/** cell右端button点击回调 */
@property (nonatomic,copy) void(^buttonClickBlock)(EVUserTableViewCell *userTableViewCell,UIButton *attentionButton);

/** 搜索出来的user的模型数据 */
@property (nonatomic,strong) EVFindUserInfo *userInfo;


@property (assign, nonatomic) BOOL hideBottomLine; /**< 是否隐藏底部分割线，YES：隐藏，NO，显示，默认为NO */

@end
