//
//  EVFantuanContributorTableViewCell.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@class EVFantuanContributorModel,EVMngUserListModel;

@interface EVFantuanContributorTableViewCell : UITableViewCell

@property (strong, nonatomic) EVFantuanContributorModel *model; /**< 云票贡献者模型 */
@property (strong, nonatomic) EVMngUserListModel *listModel;
@property (assign, nonatomic) NSInteger indexNum; /**< 排名 */
@property (copy, nonatomic) void(^logoClicked)(EVFantuanContributorModel *model);  /**< 贡献者头像被点击 */

+ (NSString *)cellID;

@end
