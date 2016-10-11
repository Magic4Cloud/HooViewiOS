//
//  CCConstKeys.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
#import "EVSystemPublic.h"

#define k_NETWORK_BAD_NOTE                      kE_GlobalZH(@"network_poor_living")


//网络状态
#define k_REQUST_FAIL                   kE_GlobalZH(@"request_fail_again")
#define CLASSNAME [NSString stringWithFormat:@"%@", [self class]]



#pragma mark - 网络code

#define kE_Auth                     @"E_AUTH"
#define kDeviceKey                  @"device"
#define kDeviceValue                @"ios"
#define kSessionIdKey               @"sessionid"
#define kOpen                       @"open"
#define kSessionIdExpireValue       @"E_SESSION"
#define kE_VIDEO_NOT_EXISTS         @"E_VIDEO_NOT_EXISTS"
#define kE_SMS_VERIFY               @"E_SMS_VERIFY"
#define kE_USER_NOT_EXISTS          @"E_USER_NOT_EXISTS"
#define kE_AUTH                     @"E_AUTH"
#define kE_AUTH_MERGE_CONFILICTS    @"E_AUTH_MERGE_CONFLICTS"
#define kE_VIDEO_PERM               @"E_VIDEO_PERM"
#define kE_SMS_SERVICE              @"E_SMS_SERVICE"
#define kE_USER_EXISTS              @"E_USER_EXISTS"
#define kE_SMS_INTERVAL             @"E_SMS_INTERVAL"
#define kE_USER_PHONE_NOT_EXISTS    @"E_USER_PHONE_NOT_EXISTS"
#define kE_VIDEO_WRONG_PASSWORD     @"E_VIDEO_WRONG_PASSWORD"
#define kE_MAX_MANAGER_NUMBER       @"E_MAX_MANAGER_NUMBER"
#define kE_MAX_USER_MANAGER         @"E_MAX_USER_MANAGER"

#define kE_SERVER                   @"E_SERVER"
#define kE_SERVICE                  @"E_SERVICE"
#define kE_RECHARGE_OPTION          @"E_RECHARGE_OPTION"
#define kE_RICEROLL_NOT_ENOUGH      @"E_RICEROLL_NOT_ENOUGH"
#define kE_SIGNIN_REPEAT            @"E_SIGNIN_REPEAT"
#define kE_ECOIN_NOT_ENOUGH         @"E_ECOIN_NOT_ENOUGH"
#define kE_PAY_ECOIN_NOT_ENOUGH     @"E_PAY_ECOIN_NOT_ENOUGH"
#define kE_PERMISSION_DENIED        @"E_PERMISSION_DENIED"

#define kRetvalKye                  @"retval"
#define kRetErr                     @"reterr"
#define kCustomErrorKey             @"kCustomErrorKey"
#define kRetinfoKey                 @"retinfo"
#define kRequestOK                  @"ok"
#define kId                         @"id"
#define kRegistered                 @"registered"
#define kBaseToolDomain             @"com.easyvaas.elapp"
#define kBaseToolErrorCode          -1
#define kFirstLoginKey              @"firstloginkey"
#define kFirstLoginValue            @"firstloginvalue"
#define kMindistance                @"min_distance"
#define kE_VIDEO_INVALID_VID        @"E_VIDEO_INVALID_VID"
#define kE_VIDEO_NOT_PREPARED       @"E_VIDEO_NOT_PREPARED"
#define kError_code                 @"error_code"

// 短信验证
#define kSms_id                     @"sms_id"
#define kSms_code                   @"sms_code"


#define kGps_latitude               @"gps_latitude"
#define kGps_longitude              @"gps_longitude"
#define kGps_minDistance            @"mindistance"

#define kDescription                @"description"
#define kNameKey                    @"name"
#define kRoom                       @"room"
#define kUserName                   @"username"
#define kAuth                       @"auth"
#define kAuthType                   @"authtype"
#define kToken                      @"token"
#define kNickName                   @"nickname"
#define kDisplayname                @"displayname"
#define kUnionid                    @"unionid"

#define kAuthTypePhone              @"phone"
#define kAuthTypeQQ                 @"qq"
#define kAuthTypeWeixin             @"weixin"
#define kAuthTypeSina               @"sina"
#define kAuthTypeEmail              @"email"
#define kImuser                     @"imuser"
#define kImpwd                      @"impwd"

#define kLogourl                    @"logourl"
#define kGender                     @"gender"
#define kBirthday                   @"birthday"
#define kLocation                   @"location"
#define kAccess_token               @"access_token"
#define kActivity                   @"activity"
#define kRefresh_token              @"refresh_token"
#define kExpires_in                 @"expires_in"
#define kSignature                  @"signature"
#define kInvite_url                 @"invite_url"

#define kAction                     @"action"
#define kNamelist                   @"namelist"
#define kSubscribe                  @"subscribe"

#define kFile                       @"file"
#define kFrom                       @"from"
#define kPts                        @"pts"
#define kModule                     @"module"
#define kUid                        @"uid"

#define kPhone                      @"phone"

#define kFriends                     @"friends"

// 分页
#define kStart                      @"start"
#define kCount                      @"count"
#define kNext                       @"next"
#define kDanmuContent               @"content"

#define kKeyWord                    @"keyword"


#define kChannel_id                 @"channel_id"
#define kRequest_id                 @"request_id"
#define kPush_id                    @"push_id"
#define kDev_token                  @"dev_token"
#define kApp_id                     @"app_id"
#define kUser_id                    @"user_id"
#define kIdfa                       @"idfa"
#define kUserExists                 @"E_AUTH_EXISTS"

#define kType                       @"type"
#define kDevid                      @"devid"
#define kUserLoginUserNotExist      @"E_USER_NOT_EXISTS"

#define kUserKey                    @"users"
#define kVideosKey                  @"videos"
#define kNoticesKey                 @"notices"
#define kNoticeIdKey                @"noticeid"

#define kUpload_thumb_url           @"upload_thumb_url"
#define kLinkid                     @"linkid"
#define kStorage                    @"storage"




#define kLikeType                   @"like"


// userLeave
#define kContacts                   @"contacts"
#define kContent                    @"content"
#define kReply_id                   @"reply_id"
#define kReply_name                 @"reply_name"
#define kWatch_id                   @"watch_id"
#define kComment_count              @"comment_count"
#define kDuration                   @"duration"
#define kLike_count                 @"like_count"
#define kCity                       @"city"
#define kWatch_count                @"watch_count"
#define kWatching_count             @"watching_count"

#define kCreate_time                @"create_time"
#define kVote_url                   @"vote_url"

#define kStart_time                 @"start_time"
#define kFinish_time                @"finish_time"
#define kVideo_count                @"video_count"
#define kVideo_title                @"video_title"

#define kPerson_count               @"person_count"
#define kH5                         @"h5"
#define kState                      @"state"
#define kActivity_id                @"activity_id"
#define kH5_url                     @"h5_url"
// activityid

#define kCreate_time_span           @"create_time_span"
#define kIs_guest                   @"is_guest"

#define kPlay_url                   @"play_url"
#define kSid                        @"sid"
#define kVid                        @"vid"
#define kCode                       @"code"
#define kTitle                      @"title"
#define kTopic_id                   @"topic_id"
#define kLive_id                    @"live_id"
#define kLive_url                   @"live_url"
#define kShare_url                  @"share_url"
#define kLiving                     @"living"
#define kPassword                   @"password"

#define kPrice                      @"price"
#define kValue                      @"value"
#define kBest                       @"best"

//兴趣标签
#define kTaglist                    @"taglist"

#define kConnect                    @"connect"
#define kReconnect                  @"reconnect"
#define kError                      @"error"
#define kDisconnect                 @"disconnect"
#define kJoin                       @"join"
#define kJoinOK                     @"joinOK"
#define kVersion                    @"version"
#define kJoinError                  @"joinError"
#define kUserLeave                  @"userLeave"


#define kObjects                    @"objects"
#define kSubobjects                 @"subjects"

#define kNewComment                 @"newComment"
#define kInfoUpdate                 @"infoUpdate"
#define kStatusUpdate               @"statusUpdate"
#define kGetComments                @"getComments"
#define kStart_id                   @"start_id"
#define kVideo_status               @"video_status"
#define kLiveStop                   @"liveStop"
#define kUser_agent                 @"user-agent"
#define kUserJoin                   @"userJoin"
#define kTitleUpdate                @"titleUpdate"
#define kTopicUpdate                @"topicUpdate"
#define kComments                   @"comments"

#define kVideolistKey               @"videolist"
#define kTopicsKey                  @"topics"
#define kTopicidKey                 @"topicid"
#define KgroupidKey                 @"groupid"
#define KGroupNameKey               @"groupname"
#define kvidlKey                    @"vidlist"
#define kCooperations               @"cooperations"


#define kSubjectIDKey               @"sid"
#define kSubjectCommentID           @"cid"


#define kVideoLiverecommendlist     @"liverecommendlist"
#define kVideoMultivideoinfo        @"multivideoinfo"
#define kPermissionKey              @"permission"
#define kThumb                      @"thumb"
#define kMode                       @"mode"
#define kGPS                        @"gps"
#define kAccompany                  @"accompany"
#define kAllowname_list             @"allowname_list"

#define kUserLogoPlaceHolder        @"avatar"
#define kDesc                       @"desc"
#define kLive_start_time            @"live_start_time"
#define kLive_stop_time             @"live_stop_time"
#define kLive_stop_time_span        @"live_stop_time_span"
#define kLive_start_time_span       @"live_start_time_span"
#define kNotices                    @"notices"

#pragma mark - Color string
#define kGlobalSeparatorColorStr    @"#d7d7d7"
#define kGlobalNaviBarBgColorStr    @"#fffcf9"

#pragma mark - global separater frame
#define kGlobalSeparatorHeight      0.3f
#define kSeparatorLeftSpace         53.0f

#pragma mark - global video bottom gradient gray layer height
#define kGlobalGrayLayerHeight   19.0f

#define kGlobalGreenColor           @"#9AC9FF"
#define kLightGrayTextColor         @"#666666"
#define k51Color                    @"#515151"
#define kGlobalWhite                @"#FFFFFF"
#define kGlobalBackButtonTitle      @""


#pragma mark - notification names

// 推送
#define kData                       @"data"
#define kAps                        @"aps"

// 预告
#define kNoticeId                   @"noticeid"

// db
#define kUpdate_time                @"update_time"

// 通讯录找好友
#define kRemarks                    @"remarks"

// 添加评论
#define kContent                    @"content"
#define KCommetnID                  @"commentid"

// 用户设置
#define kLive                       @"live"
#define kFollow                     @"follow"
#define kDisturb                    @"disturb"

// 闪屏相关
#define kDeviceType                 @"devtype"
#define kScreens                    @"screens"
#define kLastShowSplashTime         @"lastShowTime"
#define kSplashScreenRemoved        @"splashScreenRemoved"
#define kParams                     @"params"
#define kParam_content              @"param_content"
#define kParam_type                 @"param_type"
#define kEnd_time                   @"end_time"
#define kScreen_url                 @"screen_url"
#define kLike_url                   @"like_url"

#define kBgpid                      @"bgpid"
#define kBgpic                      @"bgpic"



#define kOldPwdKey                  @"old"
#define KNewPwdKey                  @"new"

// 用户资产
#define kBarley                     @"barley"
#define kDaybarley                  @"daybarley"
#define kEcoin                      @"ecoin"
#define kRiceroll                   @"riceroll"
#define kLimitcash                  @"limitcash"
#define kCash                       @"cash"

// 购买物品
#define kGoodsid                    @"goodsid"
#define kNumber                     @"number"

#define kReceipt                    @"receipt"
#define kAmount                     @"amount"
#define kApplePayVerifyErrorUsed    @"E_APPLEPAY_VALID_USED"

// 群组举报
#define kGroupIdKey                 @"groupid"
#define kDescriptionKey             @"description"

// weakSelf
#define WEAK(object) __weak typeof(object) weak##object = object;


#define kExtra                      @"extra"
#define kIsBuyBackOn                @"isBuyBackOn"

#define kReason                     @"reason"

#define kGetLiveUrl                 @"getliveurl"
#define kLiveUrl                    @"liveurl"
