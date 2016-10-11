//
//  EVBindOrChangePhoneTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVRelationWith3rdAccoutModel;

@interface EVBindOrChangePhoneTableViewCell : UITableViewCell

@property (copy, nonatomic) void(^bindOrChangePhone)(EVRelationWith3rdAccoutModel *model);  /**< 绑定或者更换手机号 */
@property (strong, nonatomic) EVRelationWith3rdAccoutModel *model; /**< 数据模型 */

+ (NSString *)cellID;
+ (CGFloat)cellHeight;

@end
