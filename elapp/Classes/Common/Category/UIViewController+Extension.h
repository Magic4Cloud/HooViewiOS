//
//  UIViewController+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVEnums.h"
@class EVWatchVideoInfo, CCForeShowItem;

@interface UIViewController (Extension)<UIScrollViewDelegate>

/**
 *  根据vid播放视频
 *
 *  @param vid 视频信息，属性vid不能为空
 *  @param play_url 播放地址,如果返回参数有该属性传进来, 用于加速
 *  @param mode 如果play_url 不为空 mode必须传进来
 *  @param permission 视频的权限
 */
- (void)playVideoWithVideoInfo:(EVWatchVideoInfo *)videoInfo permission:(EVLivePermission)permission;

/**
 *  开始一个直播
 *
 *  @param forceImage 直播开始后能否获得一张图片 如果需要获得 delegate 不能为空,并实现代理方法
 *  @param permission 直播权限
 *  @param allowList  观看权限
 *  @param audioOnly  是否音频直播
 *  @param delegate   代理 : CCLiveViewControllerDelegate 可以为 nil
 */
- (void)requestNormalLivingPageForceImage:(BOOL)forceImage
                                allowList:(NSArray *)allowList
                                audioOnly:(BOOL)audioOnly
                                 delegate:(id)delegate;

/**
 *  检查是否需要续播
 *
 *  @param normalStart    正常开市直播 ( 没有续播的情况; 有续播需要，但用户选择放弃续播 )
 *  @param continueLiving 开续续播流程
 */
- (void)checkLiveNeedToContinueStart:(void(^)())normalStart
                      continueLiving:(void(^)())continueLiving;

/**
 *  该方法用于活动详情开启直播
 *              id(NSInteger)           : 活动id 必填参数
 *              video_title(NSString)   : 选填参数, 如果指定了该参数直播的默认标题就使用该标题
 *              audio_only              : 是否需要音频直播
 *  @param delegate   代理 : CCLiveViewControllerDelegate 可以为 nil
 *  @return
 */
- (void)requestActivityLivingWithActivityInfo:(NSDictionary *)params
                                     delegate:(id)delegate;

/**
 *  开始一个预告直播
 *
 *  @param item 
 */
- (void)requestForecastLivingWithForecastItem:(CCForeShowItem *)item
                                     delegate:(id)delegate;


/**
 *  添加返回顶部的小火箭按钮
 *
 *  @param  button添加到的父视图,如果父视图是window，必须手动移除
 *  @param  y相对于底部的偏移量
 *  @param  按钮响应的block
 */
- (UIButton *)addBackToTopButtonToSuperView:(UIView *)superView
                            OffsetYToBottom:(CGFloat)offsetY_Bottom
                                     action:(SEL)action;

/**
 为导航控制器添加统一样式的返回按钮
 */
- (void)setSystemBackButton;
@end
