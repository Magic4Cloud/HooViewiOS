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
    return [TencentOAuth iphoneQQInstalled];
}

#pragma mark - weixin - WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    EVLog(@"-----");
}
#pragma mark - weixin
+ (BOOL)weixinInstall{
    return [WXApi isWXAppInstalled];
}

#pragma mark - weibo - WeiboSDKDelegate

#pragma mark - weibo
+ (BOOL)weiBoInstall{
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP] && [WeiboSDK isCanSSOInWeiboApp]) {
        return YES;
    }
    return NO;
}


#pragma mark - helper 
/**< 当参数 image 为空时，使用图标icon作为分享 image */
- (NSData *)handleShareImage:(UIImage *)shareImage maxLength:(CGFloat)maxPreviewLength {
    NSData *resultData;
    if (shareImage == nil) {
        shareImage = EVAppIcon;
    }
    resultData = [shareImage cc_imagedataWithMaxLength:maxPreviewLength];
    if (resultData.length > maxPreviewLength) {
        resultData = UIImagePNGRepresentation(EVAppIcon);
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
- (void)shareContentWithPlatform:(EVLiveShareButtonType)platform shareType:(ShareType)shareType titleReplace:(NSString *)titleReplaceString descriptionReplaceName:(NSString *)descriptionReplaceNameString descriptionReplaceId:(NSString *)descriptionReplaceIdString URLString:(NSString *)urlString image:(UIImage *)shareImage outImage:(UIImage *)outimage {
    
    NSDictionary *shareInfo = [self dictionaryInfoOfShareType:shareType
                                                         titleReplaceName:titleReplaceString
                                                   descriptionReplaceName:descriptionReplaceNameString
                                                     descriptionReplaceId:descriptionReplaceIdString
                                                   descriptionReplaceTime:nil];
    
    [self p_shareContentWithPlatform:platform
                           shareType:shareType
                               title:shareInfo[CCShareFunctionsKeyTitle]
                      descriptionStr:shareInfo[CCShareFunctionsKeyDescription]
                           URLString:urlString
                               image:shareImage
                             isVideo:[shareInfo[CCShareFunctionsKeyIsVideo] boolValue] outImage:outimage];
}

// 全参数分享方法
- (void)p_shareContentWithPlatform:(EVLiveShareButtonType)platform shareType:(ShareType)shareType title:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideo  outImage:(UIImage *)outImage {
    urlString = urlString ? : @"http://www.hooview.com/";  /**< 如果url为空使用的默认网址 */
    switch (platform) {
        case EVLiveShareQQButton: {
            [self shareContentToQQWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage shareType:shareType outImage:outImage];
            break;
        }
        case EVLiveShareWeiXinButton: {
            [self shareContentToWechatWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage shareType:shareType outImage:outImage];
            break;
        }
        case EVLiveShareSinaWeiBoButton: {
            [self shareContentToSinaWeiBoWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage isVideo:isVideo shareType:shareType outImage:outImage];
            break;
        }
        case EVLiveShareFriendCircleButton: {
            [self shareContentToWechatTimeLineWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage isVideo:isVideo shareType:shareType outImage:outImage];
            break;
        }
        case EVLiveShareQQZoneButton: {
            [self shareContentToQQZoneWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage shareType:shareType outImage:outImage];
            break;
        }
        case EVLiveShareCopyButton: {
            [self shareContentToClipboardWithTitle:shareTitle descriptionStr:descriptionString URLString:urlString image:shareImage];
            break;
        }
    }
}


#pragma mark - platforms
- (void)shareContentToQQWithTitle:(NSString *)shareTitle  descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage shareType:(ShareType)shareType outImage:(UIImage *)outImage{

    if (shareType == ShareTypeMineTextLive) {
        NSData *previewData = [self handleShareImage:outImage maxLength:maxPreviewLengthOfQQ];
        NSData *data = UIImageJPEGRepresentation(outImage, 1);
        QQApiImageObject *obj = [[QQApiImageObject alloc] initWithData:data previewImageData:previewData title:shareTitle description:descriptionString];
        QQApiSendResultCode sent = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obj]];
        [self handleSendResult:sent];
        return;
    }
    NSData *previewData = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfQQ];
    QQApiURLObject *obj = [QQApiURLObject objectWithURL:[NSURL URLWithString:urlString] title:shareTitle description:descriptionString previewImageData:previewData targetContentType:QQApiURLTargetTypeNews];
    QQApiSendResultCode sent = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obj]];
    [self handleSendResult:sent];
   
}


- (void)shareContentToWechatWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage shareType:(ShareType)shareType outImage:(UIImage *)outImage{
    if (shareType == ShareTypeMineTextLive) {
            NSData *shareData = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfWechat];
        WXImageObject *ext = [WXImageObject object];
        NSData *data = UIImageJPEGRepresentation(outImage, 1);
        ext.imageData = data;
    
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title       = shareTitle;
        message.thumbData   = shareData;
        message.description = descriptionString;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText   = NO;
        req.message = message;
        req.scene   = WXSceneSession;
        if ( ![WXApi sendReq:req] ) {
            EVLog(@"weixinSahre to friend send fail");
        }
        return;
    }
    
    NSData *data = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfWechat];
    WXWebpageObject *ext = [WXWebpageObject object];
    if ( urlString ) {
        ext.webpageUrl = urlString;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    if (shareType == ShareTypeLiveAnchor || shareType == ShareTypeGoodVideo) {
        message.title       = [NSString stringWithFormat:@"%@ %@",shareTitle,descriptionString];
    }else {
        message.title       = shareTitle;
    }
    
    message.thumbData   = data;
    message.description = descriptionString;
   
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = WXSceneSession;
    if ( ![WXApi sendReq:req] ) {
        EVLog(@"weixinSahre to friend send fail");
    }
}

- (void)shareContentToSinaWeiBoWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideoType shareType:(ShareType)shareType outImage:(UIImage *)outImage {
    if (shareType == ShareTypeMineTextLive) {
        WBMessageObject *message = [WBMessageObject message];
        NSString *content = nil;
        if (urlString) {
            if (shareTitle) {
                content = [NSString stringWithFormat:@"#火眼财经#%@", shareTitle];
            } else {
                content = [NSString stringWithFormat:@"%@%@", descriptionString, urlString];
            }
        }
        message.text = content;
        
        // 判断分享内容是否是视频类型
      
        NSData *data = UIImageJPEGRepresentation(outImage, 1);
        WBImageObject *imageObj = [[WBImageObject alloc] init];
        imageObj.imageData  = data;
        message.imageObject = imageObj;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
        return;
    }
    WBMessageObject *message = [WBMessageObject message];
    NSString *content = nil;
    if (shareType == ShareTypeLiveAnchor || shareType == ShareTypeGoodVideo ) {
        descriptionString = @"#火眼财经#";
    }
    if (urlString) {
        if (shareTitle) {
            content = [NSString stringWithFormat:@"%@%@ %@",descriptionString, shareTitle, urlString];
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
- (void)shareContentToWechatTimeLineWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage isVideo:(BOOL)isVideoType shareType:(ShareType)shareType outImage:(UIImage *)outImage {
    if (shareType == ShareTypeMineTextLive) {

        NSData *data = UIImageJPEGRepresentation(shareImage, 1);
        WXImageObject *message = [WXImageObject object];
  
        message.imageData = data;
        
     
        WXMediaMessage *mediaMs = [WXMediaMessage message];
        mediaMs.mediaObject = message;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText   = NO;
        req.message = mediaMs;
        req.scene   = WXSceneTimeline;
        if ( ![WXApi sendReq:req] ) {
            EVLog(@"weixinShareFriend to friend send fail");
        }
        return;
    }
    
    NSData *data = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfWechat];
    WXMediaMessage *message = [WXMediaMessage message];
    if (shareType == ShareTypeLiveAnchor || shareType == ShareTypeGoodVideo) {
         message.title       = [NSString stringWithFormat:@"%@ %@",shareTitle,descriptionString];
    }else {
         message.title       = shareTitle;
    }
   
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
        EVLog(@"weixinShareFriend to friend send fail");
    }

}

- (void)shareContentToQQZoneWithTitle:(NSString *)shareTitle descriptionStr:(NSString *)descriptionString URLString:(NSString *)urlString image:(UIImage *)shareImage shareType:(ShareType)shareType outImage:(UIImage *)outImage{
    if (shareType == ShareTypeMineTextLive) {
        //NSData *previewData = [self handleShareImage:shareImage maxLength:maxPreviewLengthOfQQ];
        
        //    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:shareTitle description:descriptionString previewImageData:previewData targetContentType:QQApiURLTargetTypeVideo];
        //    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        NSData *data = UIImageJPEGRepresentation(shareImage, 1);
        QQApiImageObject *obje = [QQApiImageObject objectWithData:data previewImageData:data title:shareTitle description:descriptionString];
        [obje setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        QQApiSendResultCode sent = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obje]];
        [self handleSendResult:sent];
        return;
    }
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
    
    [EVProgressHUD showSuccess:kE_GlobalZH(@"e_copy")];
}




- (NSDictionary *)dictionaryInfoOfShareType:(ShareType)type
                           titleReplaceName:(NSString *)titleReplaceName
                     descriptionReplaceName:(NSString *)descriptionReplaceName
                       descriptionReplaceId:(NSString *)descriptionReplaceId
                     descriptionReplaceTime:(NSString *)descriptionReplaceTime{
    //    EVLog(@"\nshareOrigin \ntitleName = %@, \ndesName = %@, \ndesId = %@, \ndesTime = %@", titleReplaceName, descriptionReplaceName, descriptionReplaceId, descriptionReplaceTime);
    
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
        case ShareTypeGoodVideo: {
            valueIsVideo     = @1;
            valueTitle       = [NSString stringWithFormat:@"[%@]",titleReplaceName];
            valueDescription = descriptionReplaceName;
            break;
        }
        case ShareTypeLiveAnchor:
        case ShareTypeVideoWatch: {
            valueIsVideo     = @1;
            valueTitle       = [NSString stringWithFormat:@"[%@] 正在直播:",titleReplaceName];
            valueDescription = descriptionReplaceName;
            break;
        }
        case ShareTypeMineTextLive:
        case ShareTypeOtherCentre: {
            valueTitle       = [NSString stringWithFormat:@"%@%@", titleReplaceName,@"的图文直播间"];
            valueDescription = @"";
            break;
        }
        case ShareTypeAnchorBeginLive: {
            valueTitle = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = [NSString stringWithFormat:kE_GlobalZH(@"who_living_watch_temp_living"), descriptionReplaceName];
            break;
        }
        case ShareTypeNews: {
            valueTitle       = [NSString stringWithFormat:@"%@ %@",titleReplaceName,descriptionReplaceName];
            valueDescription = @"";
            break;
        }
        case ShareTypeInviteFriend: {
            valueTitle       = kE_GlobalZH(@"easyvaas_main_slogan");
            valueDescription = kE_GlobalZH(@"watch_temp_living_social");
            break;
        }
       
        case ShareTypeNewsWeb: {
            valueTitle       = [NSString stringWithFormat:@"%@",titleReplaceName];;
            valueDescription = [NSString stringWithFormat:@"%@",descriptionReplaceName];
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
    return dicMut;
}

@end
