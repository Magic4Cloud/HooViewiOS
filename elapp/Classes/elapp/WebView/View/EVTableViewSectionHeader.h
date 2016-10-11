//
//  EVTableViewSectionHeader.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCTableViewSectionHeaderDelegate <NSObject>

@optional

- (void)rightButton:(UIButton *)btn headTitle:(NSString *)headTitle;

@end

@interface EVTableViewSectionHeader : UIView

@property (nonatomic, copy) NSString *imageName;        /**< 图片名称 */
@property (nonatomic, copy) NSString *title;            /**< 名称 */

@property (nonatomic, weak) id<CCTableViewSectionHeaderDelegate> delegate;

/**
 *  @author shizhiang, 15-09-18 11:09:50
 *
 *  带参初始化方法
 *
 *  @param imageName 图片名称
 *  @param title     名称
 *
 *  @return 本类的实例
 */
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title;

@end
