//
//  EVShareManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//
 //


#import "EVShareManager.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AFNetworking.h>

#define kTokenProtectTime 0


NSString *const CCShareFunctionsKeyTitle       = @"keyTitle";
NSString *const CCShareFunctionsKeyDescription = @"keyDescription";
NSString *const CCShareFunctionsKeyIsVideo     = @"keyIsVideo";

static const CGFloat maxPreviewLengthOfQQ     = 5 * 1024;
static const CGFloat maxPreviewLengthOfWechat = 32 * 1024;
static const CGFloat maxPreviewLengthOfSina   = 1024 * 1024 * 5;

// ************
@interface EVShareManager ()

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, assign) CCShareType shareType;    // 分享类型
@property (nonatomic, copy)   NSString *forecastTime;   // 预告开播时间

@property (nonatomic,strong) AFURLSessionManager *sessionManager;

@end

@implementation EVShareManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static EVShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[EVShareManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _sessionManager = [[AFURLSessionManager alloc] init];
    }
    return self;
}

#pragma mark - QQ   [accountDefault synchronize];

+ (BOOL)qqInstall{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}

#pragma mark - weixin - WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    CCLog(@"-----");
}
#pragma mark - weixin
+ (BOOL)weixinInstall{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

#pragma mark - weibo - WeiboSDKDelegate

#pragma mark - weibo
+ (BOOL)weiBoInstall{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://"]];
}


#pragma mark - helper 
/**< 当参数 image 为空时，使用图标icon作为分享 image */
- (NSData *)handleShareImage:(UIImage *)shareImage maxLength:(CGFloat)maxPreviewLength {
    NSData *resultData;
    if (shareImage == nil) {
        shareImage = CCAppIcon;
    }
    resultData = [shareImage cc_imagedataWithMaxLength:maxPreviewLength];
    if (resultData.length > maxPreviewLength) {
        resultData = UIImagePNGRepresentation(CCAppIcon);
    }
    
    return resultData;
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:kE_GlobalZH(@"app_not_login") delegate:nil cancelButtonTitle:kCancel otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:kNoNetworking delegate:nil cancelButtonTitle:kCancel otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:kE_GlobalZH(@"api_port_not_hold") delegate:nil cancelButtonTitle:kCancel otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:kE_GlobalZH(@"fail_send") delegate:nil cancelButtonTitle:kCancel otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


//---------------------------------------------------------------------------------------------
// >> 分享相关
//---------------------------------------------------------------------------------------------
#pragma mark - 分享相关 >>>>
#pragma mark - handle share

// 分享内容（描述中包含 name、id 两个拼接内容）
- (void)shareContentWithPlatform:(CCLiveShareButtonType)platform shareType:(ShareType)shareType titleReplace:(NSString *)titleReplaceString descriptionReplaceName:(NSString *)descriptionReplaceNameString descriptionReplaceId:(NSString *)descriptionReplaceIdString URLString:(NSString *)urlString image:(UIImage *)shareImage {
    
    NSDictionary *shareInfo = [self dictionaryInfoOfShareType:shareType
                                                         titleReplaceName:titleReplaceString
                                                   descriptionReplaceName:descriptionReplaceNameString
                                                     descriptionReplaceId:descriptionReplaceIdString
                                                   descriptionReplaceTime:nil];
    
    [self p_shareContentWithPlatform:platform
                               title:shareInfo[CCShareFunctionsKeyTitle]
                      descriptionStr:shareInfo[CCShareFunctionsKeyDescription]
                           URLString:urlString
                               image:shareImage
                             isVideo:[shareInfo[CCShareFunctionsKeyIsVideo] boolValue]];
}

// 全参数分享方法
- (void)p_shareContentWithPlatform:(CCLiveShareButtonType)platform title:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideo {
    urlString = urlString ? : @"www.easylive.com";  /**< 如果url为空使用的默认网址 */
    switch (platform) {
        case CCLiveShareQQButton: {
            [self shareContentToQQWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage];
            break;
        }
        case CCLiveShareWeiXinButton: {
            [self shareContentToWechatWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage];
            break;
        }
        case CCLiveShareSinaWeiBoButton: {
            [self shareContentToSinaWeiBoWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage isVideo:isVideo];
            break;
        }
        case CCLiveShareFriendCircleButton: {
            [self shareContentToWechatTimeLineWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage isVideo:isVideo];
            break;
        }
        case CCLiveShareQQZoneButton: {
            [self shareContentToQQZoneWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage];
            break;
        }
        case CCLiveShareCopyButton: {
            [self shareContentToClipboardWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage];
            break;
        }
    }
}


#pragma mark - platforms
- (void)shareContentToQQWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage {
    NSData *previewData = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfQQ];
    
    QQApiURLObject *obj = [QQApiURLObject objectWithURL:[NSURL URLWithString:urlString] title:shareTitle description:descriptionString previewImageData:previewData targetContentType:QQApiURLTargetTypeNews];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obj]];
    [self handleSendResult:sent];
}


- (void)shareContentToWechatWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage {
    NSData *data = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfWechat];
    WXWebpageObject *ext = [WXWebpageObject object];
    if ( urlString ) {
        ext.webpageUrl = urlString;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title       = shareTitle;
    message.thumbData   = data;
    message.description = descriptionString;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = WXSceneSession;
    if ( ![WXApi sendReq:req] ) {
        CCLog(@"weixinSahre to friend send fail");
    }
}

- (void)shareContentToSinaWeiBoWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideoType {
    WBMessageObject *message = [WBMessageObject message];
    NSString *content = nil;
    if (urlString) {
        if (shareTitle) {
            content = [NSString stringWithFormat:@"%@ %@", shareTitle, urlString];
        } else {
            content = [NSString stringWithFormat:@"%@%@", descriptionString, urlString];
        }
    }
    message.text = content;
    
    // 判断分享内容是否是视频类型
    if (!isVideoType) {
        NSData *data = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfSina];
        WBImageObject *imageObj = [[WBImageObject alloc] init];
        imageObj.imageData  = data;
        message.imageObject = imageObj;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

#pragma mark Wechat cricle
- (void)shareContentToWechatTimeLineWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideoType {
    NSData *data = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfWechat];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title       = shareTitle;
    message.thumbData   = data;
    message.description = descriptionString;
    
    // 判断分享内容是否是视频类型
    if (isVideoType) {
#ifdef CCDEBUG
        assert(urlString);
#endif
        WXVideoObject *ext  = [WXVideoObject object];
        ext.videoUrl        = urlString;
        message.mediaObject = ext;
    } else {
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl       = urlString;
        message.mediaObject     = webObj;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = WXSceneTimeline;
    if ( ![WXApi sendReq:req] ) {
        CCLog(@"weixinShareFriend to friend send fail");
    }
}

- (void)shareContentToQQZoneWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage {
    NSData *previewData = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfQQ];
    
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:shareTitle description:descriptionString previewImageData:previewData targetContentType:QQApiURLTargetTypeVideo];
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:imgObj]];
    [self handleSendResult:sent];
}

- (void)shareContentToClipboardWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage {
    NSString *content = [NSString stringWithFormat:@"%@,%@,%@",shareTitle, descriptionString, urlString];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
    
    [CCProgressHUD showSuccess:kE_GlobalZH(@"e_copy")];
}




- (NSDictionary *)dictionaryInfoOfShareType:(ShareType)type
                           titleReplaceName:(NSString *)titleReplaceName
                     descriptionReplaceName:(NSString *)descriptionReplaceName
                       descriptionReplaceId:(NSString *)descriptionReplaceId
                     descriptionReplaceTime:(NSString *)descriptionReplaceTime{
    //    CCLog(@"\nshareOrigin \ntitleName = %@, \ndesName = %@, \ndesId = %@, \ndesTime = %@", titleReplaceName, descriptionReplaceName, descriptionReplaceId, descriptionReplaceTime);
    
    NSString *valueTitle;           /**< 最终的title */
    NSString *valueDescription;     /**< 最终的description */
    NSNumber *valueIsVideo = @0;    /**< 最终的isVideo */
    
    
    if (valueTitle.length > 0 && valueDescription.length > 0) {
        return [self dictionaryWithTitle:valueTitle description:valueDescription isVideo:valueIsVideo];
    }
    
    //-----------------------------------------------------------------------------------
    // >> 网络返回数据处理错误，采用默认文案
    //-----------------------------------------------------------------------------------
    switch (type) {
        case ShareTypeLiveWatch: {
            valueIsVideo     = @1;
            valueTitle       = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = kE_GlobalZH(@"watch_temp_living_social");
            break;
        }
        case ShareTypeLiveAnchor:
        case ShareTypeVideoWatch: {
            valueIsVideo     = @1;
            valueTitle       = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = [NSString stringWithFormat:kE_GlobalZH(@"who_living_watch_temp_living"), descriptionReplaceName];
            break;
        }
        case ShareTypeMineCentre:
        case ShareTypeOtherCentre: {
            valueTitle       = [NSString stringWithFormat:@"%@%@", titleReplaceName,kE_GlobalZH(@"who_user_homepage")];
            valueDescription = [NSString stringWithFormat:kE_GlobalZH(@"easyvaas_user_homepage"), descriptionReplaceName];
            break;
        }
        case ShareTypeAnchorBeginLive: {
            valueTitle = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = [NSString stringWithFormat:kE_GlobalZH(@"who_living_watch_temp_living"), descriptionReplaceName];
            break;
        }
        case ShareTypeActivity: {
            valueTitle       = titleReplaceName;
            valueDescription = [NSString stringWithFormat:@"%@%@",kE_GlobalZH(@"easyvaas_main_slogan"), descriptionReplaceName];
            break;
        }
        case ShareTypeInviteFriend: {
            valueTitle       = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = kE_GlobalZH(@"watch_temp_living_social");
            break;
        }
       
        case ShareTypeMineVideo: {
            valueTitle       = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = [NSString stringWithFormat:kE_GlobalZH(@"who_living_watch_temp_living"), descriptionReplaceName];
            break;
        }
    }
    
    return [self dictionaryWithTitle:valueTitle description:valueDescription isVideo:valueIsVideo];
}


#pragma mark - helper
- (NSDictionary *)dictionaryWithTitle:(NSString *)title description:(NSString *)description isVideo:(NSNumber *)isVideo {
    NSMutableDictionary *dicMut = [NSMutableDictionary dictionary];
    if (title) {
        dicMut[CCShareFunctionsKeyTitle]       = title;
    }
    if (description) {
        dicMut[CCShareFunctionsKeyDescription] = description;
    }
    if (isVideo) {
        dicMut[CCShareFunctionsKeyIsVideo]     = isVideo;
    }
    //    CCLog(@"dictionary = %@", dicMut);
    return dicMut;
}



@end
