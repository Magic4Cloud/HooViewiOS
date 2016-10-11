//
//  EVLivePrePareView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVAudioOnlyBackGroundView.h"

@class EVLivePrePareView;

// 按钮的类型 －> tag
typedef NS_ENUM(NSInteger, EVLivePrePareViewButtonType)
{
    EVLivePrePareViewButtonCancel = 100,
    EVLivePrePareViewButtonCover,
    EVLivePrePareViewButtonLiveStart,
    EVLivePrePareViewButtonToggleCamera,
    EVLivePrePareViewButtonCaptureAnImage,
    EVLivePrePareViewButtonBeauty,
    EVLivePrePareViewButtonPermission,
    EVLivePrePareViewButtonCategory,
};

// 用户选择分享的类型
typedef NS_ENUM(NSInteger, EVLivePrePareViewShareType) {
    EVLivePrePareViewShareNone = 0,
    EVLivePrePareViewShareSina,
    EVLivePrePareViewShareWeixin,
    EVLivePrePareViewShareFriendCircle,
    EVLivePrePareViewShareQQ
};



@protocol CCLivePrePareViewDelegate <NSObject>

@optional
- (void)livePrePareView:(EVLivePrePareView *)view didClickButton:(EVLivePrePareViewButtonType)type;

@end


// 准备界面
@interface EVLivePrePareView : UIView

@property (nonatomic, weak) UIButton *categoryButton;

/** 分享类型 */
@property (nonatomic,assign) EVLivePrePareViewShareType currShareTye;

/** 进度条底下的提示信息 */
- (void)setLoadingInfo:(NSString *)loadingInfo canStart:(BOOL)start;


/** 用来标识是否截图成功 */
@property (nonatomic, assign) BOOL captureSuccess;
@property (nonatomic,copy) NSString *title;
@property ( strong, nonatomic ) UIImage *coverImage; /**< 封面图片 */

- (void)startCaptureImage;
- (void)endCaptureImage;

/**
 *  直播准备界面推出的方法
 */
- (void)disMiss;

/** 代理 */
@property (nonatomic, weak) id<CCLivePrePareViewDelegate>delegate;

@end
