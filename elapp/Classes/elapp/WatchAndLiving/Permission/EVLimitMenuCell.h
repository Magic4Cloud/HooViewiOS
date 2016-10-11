//
//  EVLimitMenuCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
// cell 的数据模型
@interface CCLimitMenuCellItem : NSObject
/** 是否被选中 */
@property (nonatomic, assign) BOOL selected;
/** cell 的title */
@property (nonatomic, copy  ) NSString *title;
/** 描述信息 */
@property (nonatomic, copy  ) NSString *cellDescription;
/** 是否可以被展开 */
@property (nonatomic, assign) BOOL extend;
/** 权限类型 */
@property (nonatomic, assign) EVLivePermission permission;
/** 是否有箭头 */
@property (nonatomic, assign) BOOL hasIndecator;
/** 是否显示右侧提示 */
@property (nonatomic, assign) BOOL showRightNotice;
/** 密码 */
@property (nonatomic, copy  ) NSString *password;
/** 付费直播金额 */
@property (nonatomic, copy  ) NSString *price;

@end

@interface EVLimitMenuCell : UITableViewCell
/** 数据模型 */
@property (nonatomic, strong) CCLimitMenuCellItem *menuCellItem;

@end
