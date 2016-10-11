//
//  EVLimitHeaderView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
// 按钮类型 -> tag
typedef NS_ENUM(NSInteger, EVLimitHeaderViewButtonType) {
    EVLimitHeaderViewButtonCancel,
    EVLimitHeaderViewButtonComfirm
};

@protocol EVLimitHeaderViewDelegate <NSObject>

@optional
- (void)limitHeaderViewDidClickButton:(EVLimitHeaderViewButtonType)type;

@end

@interface EVLimitHeaderView : UIView

@property (nonatomic, weak) id<EVLimitHeaderViewDelegate>delegate;

/**
 *  初始化方法
 *
 *  @return 
 */
+ (instancetype)limitHeaderView;

- (void)configTitle:(NSString *)titleString;

@end
