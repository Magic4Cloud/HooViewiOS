//
//  EVLivePrePareView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVLivePrePareView,EVLiveTitleTextView;

// 按钮的类型 －> tag
typedef NS_ENUM(NSInteger, EVLivePrePareViewButtonType)
{
    EVLivePrePareViewButtonCancel = 100,
    EVLivePrePareViewButtonCover,
    EVLivePrePareViewButtonLiveStart,
    EVLivePrePareViewButtonToggleCamera,
    EVLivePrePareViewButtonCaptureAnImage,
    EVLivePrePareViewButtonPermission,
    EVLivePrePareViewButtonCategory,
};

// 用户选择分享的类型
typedef NS_ENUM(NSInteger, EVLivePrePareViewShareType) {
    EVLivePrePareViewShareNone = 0,
    EVLivePrePareViewShareSina,
    EVLivePrePareViewShareWeixin,
    EVLivePrePareViewShareFriendCircle,
    EVLivePrePareViewShareQQ,
    EVLivePrePareViewShareQQZone
};



@protocol EVLivePrePareViewDelegate <NSObject>

@optional
- (void)livePrePareView:(EVLivePrePareView *)view didClickButton:(EVLivePrePareViewButtonType)type;

@end


// 准备界面
@interface EVLivePrePareView : UIView
@property (nonatomic,weak) EVLiveTitleTextView *editView;

@property (nonatomic, weak) UIButton *categoryButton;
@property (nonatomic,weak) UIButton *startLiveButton;

@property (nonatomic, weak) UITextField *editTextFiled;

@property (nonatomic, strong) UITextField *payFeeTextFiled;

/**
 付费输入价格背景视图
 */
@property (nonatomic, strong) UIView * payFeeBackView;

/**
 标题背景视图
 */
@property (nonatomic, strong) UIView * titleBackView;

/**
 标题输入框的顶部约束  （付费和免费修改约束）
 */
@property (nonatomic, strong) NSLayoutConstraint * topOfTitleBackViewConstraint;
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
@property (nonatomic, weak) id<EVLivePrePareViewDelegate>delegate;

/**
 是否是付费直播
 */
@property (nonatomic, assign)BOOL isPayLive;
@end
