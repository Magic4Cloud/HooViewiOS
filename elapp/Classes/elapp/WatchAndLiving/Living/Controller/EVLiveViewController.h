//
//  EVLiveViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVVideoViewController.h"
#import "EVEnums.h"
#import "EVLivePrePareView.h"

@class CCForeShowItem, EVLiveViewController;

typedef NS_ENUM(NSInteger, CCLiveControllerStyle) {
    CCLiveControllerStyleDefault,
    CCLiveControllerStyleRemoveSetting
};

@protocol CCLiveViewControllerDelegate <NSObject>

@optional
// 直播需要绑定手机, 请监听改回调
- (void)liveNeedToBindPhone:(EVLiveViewController *)liveVC;

// session过期需要重新登录
- (void)liveNeedToRelogin:(EVLiveViewController *)liveVC;

/**
 *  info
 *      vid     :
 *      thumb   : 可能为空
 *
 */
- (void)liveDidStart:(EVLiveViewController *)liveVC info:(NSDictionary *)info;

@end

/**
 *  使用此控制器之前请包一个导航控制器
 */
@interface EVLiveViewController : EVVideoViewController

@property(nonatomic, assign) CCLiveControllerStyle style;

@property(nonatomic, weak) EVLivePrePareView *prepareView;

/**
 *  foreCapture ＝ YES ,代理方法 thumb 会把截图传出
 */
@property(nonatomic, assign) BOOL foreCapture;

@property(nonatomic, strong) NSDictionary *liveParams;

@property(nonatomic, weak) id <CCLiveViewControllerDelegate> delegate;


/**
 *  密码直播
 *
 *  @param passwordInfo 密码信息
 *
 *
 *  @return
 */
+ (instancetype)liveViewControllerWithPasswordInfo:(NSDictionary *)passwordInfo;

/**
 *  当点击推送的那一刻，正在直播的话，调用此方法来询问用户是否关闭当前直播
 *
 *  @param complete
 */
- (void)forceToShutDown:(void (^)())complete;

/**
 *  该方法用于活动详情开启直播
 *              id(NSInteger)         : 活动id 必填参数
 *              video_title(NSString) : 选填参数, 如果指定了该参数直播的默认标题就使用该标题
 *              audio_only            : 是否音频直播
 *  @return
 */
+ (instancetype)liveViewControllerWithActivityInfo:(NSDictionary *)params;

@end
