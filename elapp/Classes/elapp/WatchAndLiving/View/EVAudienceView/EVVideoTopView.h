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

#define CCAUDIENCEINFOVIEW_HEIGHT 37
#define CCICON_HEIGHT             50
#define CCBACKVIEW_HEIGHT         35
#define CCBACKVIEW_WIDTH          125

typedef NS_ENUM(NSInteger, CCAudienceInfoItemMode)
{
    CCAudienceInfoItemReplay,
    CCAudienceInfoItemWatchLive,
    CCAudienceInfoItemLiving
};

typedef NS_ENUM(NSInteger, CCAudienceInfoViewButtonType)
{
    CCAudienceInfoIndexPage = 100, // 进入主播主页
    CCAudienceInfoMessage,      // 私信主播
    CCAudienceInfoComment,      // @主播
    CCAudienceInfoFocus,        // 关注主播
    CCAudienceInfoReport,       // 举报视频
    CCAudienceInfoCancel,       // 关闭页面
    CCAudienceInfoSessionExpire, // session过期
    CCAudienceInfoCamera,    // 前后置摄像头
    CCAudienceInfoFollow
};

typedef NS_ENUM(NSInteger, CCAudiencceInfoViewProtocolDataType)
{
    CCAudiencceInfoViewProtocolLike
};

@protocol CCAudiencceInfoViewDelegate <NSObject>

@optional
- (void)audienceInfoView:(EVVideoTopView *)view
              didClicked:(CCAudienceInfoViewButtonType)buttonType;

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
@property (nonatomic, assign) CCAudienceInfoItemMode mode;
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




@interface EVVideoTopView : UIView <CCControllerContacterProtocol>

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


