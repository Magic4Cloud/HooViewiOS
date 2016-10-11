//
//  EVTopContributorView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVFantuanContributorModel;
typedef enum : NSUInteger {
    CCTopContributorTop1 = 1,   /** 第一名 */
    CCTopContributorTop2 = 2,   /** 第二名 */
    CCTopContributorTop3 = 3,   /** 第三名 */
} CCTopContributorType;

@protocol CCTopContributorViewDelegate <NSObject>

- (void)logoClicked:(EVFantuanContributorModel *)model;

@end

@interface EVTopContributorView : UIView

@property (strong, nonatomic) EVFantuanContributorModel *model; /**< 贡献者模型 */
@property (assign, nonatomic) CCTopContributorType type; /**< 贡献者排名类型 */
@property (weak, nonatomic) id<CCTopContributorViewDelegate> delegate;  /**< 代理 */

@end
