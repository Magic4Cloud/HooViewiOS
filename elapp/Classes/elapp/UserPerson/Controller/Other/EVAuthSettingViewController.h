//
//  EVAuthSettingViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"

typedef NS_ENUM(NSUInteger, EVAuthSectionType) {
    EVAuthSectionTypeSwitch,                /**< 开关组 */
    EVAuthSectionTypeIndicator,             /**< push组 */
    EVCacheClearSection,                    /**< 清除缓存 */
};

typedef NS_ENUM(NSUInteger, EVAuthSwithType) {
    EVAuthSwithTypeFocus,                   /**< 关注行 */
    EVAuthSwithTypeDisturb                  /**< 免打扰行 */
};

@class EVUserModel;
@interface EVAuthSettingViewController : EVViewController

@property ( strong, nonatomic ) EVUserModel *userModel;


@end
