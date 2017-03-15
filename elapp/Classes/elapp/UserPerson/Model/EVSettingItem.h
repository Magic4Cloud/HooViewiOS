//
//  EVSettingItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

typedef enum : NSUInteger {
    EVSettingItemTypeDefault = 0,                    /**< show a cell with nothing */
    EVSettingItemTypeAccountBinding = 1,             /**< to bind an account such as qq, weibo, phone NO. and so on */
    EVSettingItemTypeAddFriend,                      /**< find a person and then make a friend */
    EVSettingItemTypeAbout,                          /**< introduce the app and its owner */
    EVSettingItemTypeSetting,                        /**< setting */
    EVSettingItemTypeWhetherLocationPublic,          /**< decide whether make your location to others */
    EVSettingItemTypeLogout,                         /**< logout */
    EVSettingItemTypeForecast,                       /**< forecast video show, so consumers can watch the video on time */
    EVSettingItemTypeSign,                           /**< 签到 */
    EVSettingItemTypeScore,                          /**< 积分 */
} EVSettingItemType;

@interface EVSettingItem : EVBaseObject

@property (copy, nonatomic) NSString *iconName;         /**< 图标名称 */
@property (copy, nonatomic) NSString *title;            /**< 名称 */
@property (copy, nonatomic) NSString *subTitle;         /**< 子标题 */
@property (assign, nonatomic) EVSettingItemType type;   /**< 类型 */

+ (instancetype) itemWithIconName:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle type:(EVSettingItemType)type;

@end
