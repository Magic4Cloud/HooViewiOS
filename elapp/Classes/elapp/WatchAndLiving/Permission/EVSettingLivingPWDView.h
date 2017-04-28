//
//  EVSettingLivingPWDView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSettingLivingPWDViewDelegate <NSObject>

- (void)passwordDidChange:(nullable NSString *)pwd;

@end

@interface EVSettingLivingPWDView : UIView

@property (copy, nonatomic, nullable) NSString *lastPwd;  /**< 上次设置的密码，更改密码的时候带进来 */

@property (weak, nonatomic) id<CCSettingLivingPWDViewDelegate> delegate;  /**< 代理 */

- (void)showAndCatchResult:(void(^)(NSString *_Nullable password)) complete;

+ (void)showAndCatchResultWithSuperView:(nonnull UIView *)superView offsetY:(CGFloat)offsetY complete:(void(^_Nullable)(NSString *_Nullable password))complete;

@end
