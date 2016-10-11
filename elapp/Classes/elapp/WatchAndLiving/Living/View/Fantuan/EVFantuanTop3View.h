//
//  EVFantuanTop3View.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVFantuanContributorModel;

@interface EVFantuanTop3View : UIView

@property (strong, nonatomic) NSArray *top3Contributors; /**< 云票贡献前三的用户 */

@property (copy, nonatomic) void(^logoClicked)(EVFantuanContributorModel *model);  /**< 贡献者头像被点击 */

@end
