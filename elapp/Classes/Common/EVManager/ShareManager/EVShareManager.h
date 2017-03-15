//
//  EVShareManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeGoodVideo       = 1,       /**< 用户观看直播 */
    ShareTypeLiveAnchor      = 2,       /**< 主播端直播 */
    ShareTypeVideoWatch      = 3,       /**< 回放 */
    ShareTypeMineTextLive      = 4,       /**< 个人中心 */
    ShareTypeOtherCentre     = 5,       /**< 他人中心 */
    ShareTypeAnchorBeginLive = 8,       /**< 主播开播分享 */
    ShareTypeNews       = 9,       /**< 活动 */
    ShareTypeInviteFriend    = 12,      /**< 邀请好友 */
    ShareTypeNewsWeb       = 14,      /**< 个人中心视频 */
};

extern NSString *const CCShareFunctionsKeyTitle;
extern NSString *const CCShareFunctionsKeyDescription;
extern NSString *const CCShareFunctionsKeyIsVideo;


@interface EVShareManager : NSObject

+ (instancetype)shareInstance;


#pragma mark - weixin
+ (BOOL)weixinInstall;

#pragma mark - weibo
+ (BOOL)weiBoInstall;

#pragma mark - QQ
+ (BOOL)qqInstall;


//---------------------------------------------------------------------------------------------
// >> 分享相关
//---------------------------------------------------------------------------------------------
#pragma mark - 分享相关
/**
 *  分享内容（描述中包含 name、id 两个拼接内容）
 */
- (void)shareContentWithPlatform:(EVLiveShareButtonType)platform
                       shareType:(ShareType)shareType
                    titleReplace:(NSString *)titleReplaceString
          descriptionReplaceName:(NSString *)descriptionReplaceNameString
            descriptionReplaceId:(NSString *)descriptionReplaceIdString
                       URLString:(NSString *)urlString
                           image:(UIImage *)shareImage outImage:(UIImage *)outimage;



@end
