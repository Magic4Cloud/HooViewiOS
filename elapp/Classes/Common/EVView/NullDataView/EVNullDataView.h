//
//  EVNullDataView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVNullDataView : UIView

@property ( strong, nonatomic, nullable ) UIImage *topImage;  /**< 上部图片 */
@property (copy, nonatomic, nullable) NSString *title;        /**< 标题 */
@property (copy, nonatomic, nullable) NSString *subtitle;     /**< 子标题 */
@property (copy, nonatomic, nullable) NSString *buttonTitle;  /**< 按钮标题 */

- (void)addButtonTarget:(nonnull id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)show;

- (void)hide;

- (void)hideButton:(BOOL)YorN;

@end
