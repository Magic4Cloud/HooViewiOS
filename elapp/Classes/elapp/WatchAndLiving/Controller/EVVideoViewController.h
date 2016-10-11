//
//  EVVideoViewController.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVViewController.h"
#import "EVAudienceChatTextView.h"
#import "EVVideoViewProtocol.h"
#import "EVVideoTopView.h"
#import "EVLiveShareView.h"
#import "EVPresentView.h"
#import "EVCommentTableView.h"
#import "EVFloatingView.h"
#import "EVRiceAmountView.h"
#import "EVCenterPresentView.h"
#import "EVReportReasonView.h"
#import "EVRecordControlView.h"
#import "EVEnterAnimationView.h"
#import "EVMagicEmojiView.h"
#import "EVComment.h"
#import "EVAudienceLoveView.h"

@interface CCContentView : UIView

@end

@class EVLiveTipsLabel,EVUserModel;
@interface EVVideoViewController : EVViewController <UIScrollViewDelegate, CCVideoViewProtocol, CCLiveShareViewDelegate, CCFloatingViewDelegate>

/** 处理数据 */
/** 回复评论 */

/** 是否是要发送评论，需要显示评论框的时候为yes */
@property ( nonatomic ) BOOL sendComment;

// MARK: live and watch common element

/** vid */
@property ( nonatomic, copy ) NSString *vid;


/** 当前用户云播号 */
@property ( nonatomic, copy ) NSString *name;

/** 事件传递 */
@property (nonatomic, strong) EVControllerContacter *contacter;

/** 滑屏 */
@property ( nonatomic, weak, readonly ) UIScrollView *slidScrollView;

/** 显示内容的view */
@property ( nonatomic, weak, readonly ) UIView *contentView;

/** 文字输入 */
@property ( nonatomic, weak, readonly ) EVAudienceChatTextView *chatTextView;

/** 聊天容器 */
@property ( nonatomic, weak, readonly ) UIView *chatContainerView;

/** 视频界面上部关于主播内容和视频内容的部分 */
@property ( nonatomic, weak) EVVideoTopView *videoInfoView;

/** 收到礼物提示 */
@property ( nonatomic, weak, readonly ) EVPresentView *presentView;
@property (weak, nonatomic) EVUserModel *reportedUser; /**< 被举报人 */
/** 礼物动画 */
@property ( nonatomic, weak, readonly ) EVCenterPresentView *presentAnimatingView;

/** 礼物列表 */
@property ( nonatomic, weak ) EVMagicEmojiView *magicEmojiView;

/**< 分享 */
@property (nonatomic, weak) EVLiveShareView *shareView;

@property ( nonatomic, weak, readonly ) EVRiceAmountView *riceAmountView;

/** 显示点赞 */
@property ( nonatomic, weak, readonly ) EVAudienceLoveView *loveView;

/** 底部按钮的容器 */
/*
 *  在观看页面是CCWatchBottomItemView
 *  在直播页面是CCLiveBottomItemView
 */
@property ( nonatomic, weak ) UIView *bottomBtnContainerView;

/** 播放控制视图的容器 */
@property (nonatomic, weak) EVRecordControlView * recordControlView;

/** 评论列表 */
@property ( nonatomic, weak, readonly ) EVCommentTableView *commentTableView;

@property ( nonatomic, weak ) NSLayoutConstraint *commentTableBottomConstraint;
/** 聊天和用户加入的容器bottom约束 */
@property ( nonatomic, weak ) NSLayoutConstraint *commentAndUserJoinContainerViewConstraint;

/** 观众信息浮动窗口 */
@property ( weak, nonatomic, readonly ) EVFloatingView *floatView;

// 举报原因
@property (nonatomic, weak) EVReportReasonView *reportReasonView;


/** 进场动画 */
@property ( nonatomic, strong, readonly) EVEnterAnimationView *enterAnimationView;

@property (nonatomic,assign) BOOL isShutupUser;
@property (nonatomic,assign) BOOL isManagerUser;
/* 禁言的名字数组*/
@property (nonatomic,strong) NSMutableArray *shutupUsers;

@property (nonatomic,strong) NSMutableArray *managerUser;
/** 直播状态提醒 */
@property ( nonatomic, weak ) EVLiveTipsLabel *tipsLabel;

@property (nonatomic, weak) NSLayoutConstraint *AudienceViewConstraint;

@property (nonatomic, assign, readonly) BOOL joinMessageTopicSuccess;

//直播的房间
@property (nonatomic, copy) NSString *topicVid;


/** 主播云播号 */
@property ( nonatomic, copy ) NSString *anchorName;


@property (nonatomic, assign) BOOL livingStatus;

@property (nonatomic, assign) NSUInteger like_count;

@property (nonatomic, assign) NSUInteger watch_count;


@property (nonatomic, assign) BOOL isSelfBrush;


- (void)audienceDidClicked:(CCAudienceInfoViewButtonType)btn;

/**
 *  @author shizhiang, 16-03-08 11:03:33
 *
 *  展示分享页面
 */
- (void)showShareView;

/**
 *  @author shizhiang, 16-03-08 15:03:16
 *
 *  重新登录
 */
- (void)sessionExpireAndRelogin;

/**
 *  @author shizhiang, 16-03-09 10:03:18
 *
 *  退出视频，开始私信聊天
 */
- (void)logoutVideoAndChatWithName:(NSString *)name;

/**s
 *  @author shizhiang, 16-03-09 10:03:45
 *
 *  更新视频信息
 *
 *  @param videoInfo 视频信息
 */
- (void)updateVideoInfo:(NSDictionary *)videoInfo;

/**
 *  @author shizhiang, 16-03-15 20:03:22
 *
 *  根据礼物存放路径找到礼物动画路径
 *
 *  @param path 礼物存放路径
 *
 *  @return 礼物动画资源路径
 */
- (NSString *)presentAniDirectoryWithPath:(NSString *)path;

- (void)riceAmoutViewDidSelect;


- (void)shutupAudienceWithAudienceName:(NSString *)name shutupState:(BOOL)shutup;

/**
 *  举报用户和视频方法
 *
 *  @param title <#title description#>
 */
- (void)reportUserTitle:(NSString *)title;

- (void)addLoveView;

- (void)focusAudienceWithUserModel:(EVUserModel *)userModel;

// 跳转个人中心
- (void)showUserCenterWithName:(NSString *)name fromLivingRoom:(BOOL)fromLivingRoom;

- (void)gotoLetterPageWithUserModel:(EVUserModel *)userModel;

- (void)audienceShutedupDenied;

- (void)audienceShutedup;



- (void)hiddenContentSubviews;


@end
