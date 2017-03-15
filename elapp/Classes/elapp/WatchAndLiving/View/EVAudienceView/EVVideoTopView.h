//
//  EVVideoTopView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVControllerContacter.h"
#import "EVTopicItem.h"
#import "EVUserModel.h"

@class EVVideoTopView, EVBaseToolManager;


#define CCICON_HEIGHT             50
#define CCBACKVIEW_HEIGHT         35
#define CCBACKVIEW_WIDTH          125

typedef NS_ENUM(NSInteger, EVAudienceInfoItemMode)
{
    EVAudienceInfoItemReplay,
    EVAudienceInfoItemWatchLive,
    EVAudienceInfoItemLiving
};

typedef NS_ENUM(NSInteger, EVAudienceInfoViewButtonType)
{
    EVAudienceInfoIndexPage = 100, // 进入主播主页
    EVAudienceInfoMessage,      // 私信主播
    EVAudienceInfoComment,      // @主播
    EVAudienceInfoFocus,        // 关注主播
    EVAudienceInfoReport,       // 举报视频
    EVAudienceInfoCancel,       // 关闭页面
    EVAudienceInfoSessionExpire, // session过期
    EVAudienceInfoCamera,    // 前后置摄像头
    EVAudienceInfoFollow
};

typedef NS_ENUM(NSInteger, CCAudiencceInfoViewProtocolDataType)
{
    CCAudiencceInfoViewProtocolLike
};

@protocol CCAudiencceInfoViewDelegate <NSObject>

@optional
- (void)audienceInfoView:(EVVideoTopView *)view
              didClicked:(EVAudienceInfoViewButtonType)buttonType;

@end

@protocol CCAudiencceInfoViewProtocol <NSObject>

@optional
- (void)audienceInfoViewUpdate:(CCAudiencceInfoViewProtocolDataType)type
                         count:(NSInteger)count;

@end

@interface EVAudienceInfoItem : NSObject

// AUDIENCE_UPDATE_INFO

/** 头像地址  AUDIENCE_UPDATE_ICON */
@property (nonatomic,copy) NSString *iconURLString;
/** 模式 AUDIENCE_UPDATE_TIME_MODE */
@property (nonatomic, assign) EVAudienceInfoItemMode mode;
/** 观看人数 AUDIENCE_UPDATE_WATCH_COUNT */
@property (nonatomic, assign) NSInteger watchCount;
/** 观看中的人数 AUDIENCE_UPDATE_WATCHING_COUNT */
@property (nonatomic, assign) NSInteger watchingCount;
/** 点赞数 AUDIENCE_UPDATE_LIKE_COUNT */
@property (nonatomic, assign) NSInteger likeCount;
/** 播放时间 */
@property (nonatomic,copy) NSString *time;
/** 主播性别 */
@property (nonatomic,copy) NSString *gender;

/** 标示是否直播端 AUDIENCE_UPDATE_WATCH_SIDE */
@property (nonatomic, assign) BOOL watchSide;

@property (nonatomic, assign) BOOL flashLightOn;

@property (nonatomic, assign) BOOL fontCamera;

/** 视频数 */
@property (nonatomic, assign) NSInteger videoCount;
/** 音频数 */
@property (nonatomic, assign) NSInteger audioCount;
/** 关注数 */
@property (nonatomic, assign) NSInteger focusCount;
/** 粉丝数 */
@property (nonatomic, assign) NSInteger fansCount;
/** 是否关注 */
@property (nonatomic, assign) BOOL followed;
/** 标题  AUDIENCE_UPDATE_TITLE */
@property (nonatomic,copy) NSString *title;
/** 地区 AUDIENCE_UPDATE_LOCATION */
@property (nonatomic,copy) NSString *location;
/** 昵称 AUDIENCE_UPDATE_NICKNAME */
@property (nonatomic,copy) NSString *nickname;
/** 视云号 */
@property (nonatomic,copy) NSString *name;
/** 当前用户名字 */
@property (nonatomic,copy) NSString *currUserName;
/** 标示是否成功获取主播信息 */
@property (nonatomic, assign) BOOL getUserInfoSuccess;
/** 话题 */
@property (nonatomic,strong) EVTopicItem *topic;
/** 用户数据模型 */
@property (nonatomic,strong) EVUserModel *userModel;

@property (nonatomic,assign) NSInteger certification;

@property (nonatomic, assign) NSInteger costecoin;


@end

@interface EVAnchorInfoView : UIView

/** 是否展开 */
@property (nonatomic, assign, readonly) BOOL open;


@end




@interface EVVideoTopView : UIView <EVControllerContacterProtocol>

@property (nonatomic, strong) EVAudienceInfoItem *item;
@property (nonatomic, weak) EVAnchorInfoView *extendView;
@property (nonatomic, weak) id<CCAudiencceInfoViewDelegate> delegate;

@property (nonatomic, weak) id<CCAudiencceInfoViewProtocol> protocalDelegate;

@property (nonatomic, weak) EVBaseToolManager *engine;
@property (nonatomic, strong) EVControllerItem *listenerItem;
@property (nonatomic, strong) EVControllerContacter *contacter;

@property (nonatomic,weak, readonly) UIButton *cameraButton;

@property (nonatomic, assign) BOOL isLivingRoom;

@property (nonatomic, weak) NSLayoutConstraint *backViewConstraint;



- (void)buttonDidClicked:(UIButton *)btn;
- (void)goToFront;
- (void)close;
- (void)closeNoAnimation;

@end


