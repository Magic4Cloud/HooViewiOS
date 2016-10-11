//
//  EVNetWorkManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVNetWorkManager.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <DeviceUtil.h>
#import <objc/runtime.h>
#import "NSObject+Extension.h"

// 协助服务器实现 dns 开关
#define CC_NETWORK_DNS 0

@implementation EVNetWorkRequest

- (instancetype)initWithURLString:(NSString *)urlString
{
    if ( self = [super init] )
    {
        self.urlString = urlString;
        self.httpMethod = CCNetWorkHTTPMethodGet;
    }
    return self;
}

+ (instancetype)netWorkRequestURLString:(NSString *)urlString
{
    return [[self alloc] initWithURLString:urlString];
}

- (NSString *)dataFromParams
{
    NSMutableString *paramStr = [NSMutableString string];
    NSInteger paramCount = self.getParams.count;
    __block NSInteger index = 0;
    [self.getParams enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    return paramStr;
}

- (NSString *)urlString
{
    if ( self.httpMethod == CCNetWorkHTTPMethodPost || !self.getParams )
    {
        return _urlString;
    }
    return [self requestURLStringFromHttpGet];
}

- (NSString *)requestURLStringFromHttpGet
{
#ifdef CCDEBUG
    NSAssert(self.httpMethod == CCNetWorkHTTPMethodGet, @"http method can not be POST");
#endif
    if ( !self.getParams )
    {
        return _urlString;
    }
    return [NSString stringWithFormat:@"%@?%@",_urlString,[self dataFromParams]];
}

@end


@interface ASIHTTPRequest (Aditional)

+ (instancetype)requestWithURLString:(NSString *)urlString;

#if CC_NETWORK_DNS
@property (nonatomic, assign) BOOL peerDidSet;
@property (nonatomic,strong) NSDictionary *peerDictionary;
@property (nonatomic,copy) NSString *peer;
#endif

@end

@implementation ASIHTTPRequest (Aditional)

+ (void)load
{
    [self cc_exchangeClassMethod1:@selector(defaultUserAgentString) method2:@selector(cc_defaultUserAgentString)];
#if CC_NETWORK_DNS
    [self cc_exchangeInstanceMethod1:@selector(proxyHost) method2:@selector(cc_proxyHost)];
#endif
}

+ (instancetype)requestWithURLString:(NSString *)urlString
{
    ASIHTTPRequest *request = [[self class] requestWithURL:[NSURL URLWithString:urlString]];
    return request;
}

#if CC_NETWORK_DNS
// peer标志
static const char *peerDidSetKey;
- (void)setPeerDidSet:(BOOL)peerDidSet
{
    objc_setAssociatedObject(self, peerDidSetKey, @(peerDidSet), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)peerDidSet
{
    return [objc_getAssociatedObject(self, peerDidSetKey) boolValue];
}

// peer字典属性
static const char *peerDictionaryKey;
- (void)setPeerDictionary:(NSDictionary *)peerDictionary
{
    objc_setAssociatedObject(self, peerDictionaryKey, peerDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)peerDictionary
{
    return objc_getAssociatedObject(self, peerDictionaryKey);
}

// peer
static const char *peerKey;
- (void)setPeer:(NSString *)peer
{
    objc_setAssociatedObject(self, peerKey, peer, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)peer
{
    return objc_getAssociatedObject(self, peerKey);
}

- (NSString *)cc_proxyHost
{
    if ( [self.url.absoluteString hasPrefix:@"https"] && readStream && request && !self.peerDidSet )
    {
        self.peerDictionary = [self peerDictionaryWithPeer:self.peer];
        CFReadStreamSetProperty((CFReadStreamRef)readStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(self.peerDictionary));
        self.peerDidSet = YES;
    }
    return [self cc_proxyHost];
}

- (NSDictionary *)peerDictionaryWithPeer:(NSString *)peer
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
            [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
            [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
            (CFStringRef)peer,kCFStreamSSLPeerName, nil];
}
#endif

+ (NSString *)cc_defaultUserAgentString
{
    @synchronized (self)
    {
        static NSString *cc_defaultUserAgent = nil;
        if (!cc_defaultUserAgent)
        {
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            
            NSString *appName = @"easyvaas";
            
            NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
            appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
            
            if (!appName)
            {
                return nil;
            }
            
            NSString *appVersion = nil;
            NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
            if (marketingVersionNumber && developmentVersionNumber)
            {
                if ([marketingVersionNumber isEqualToString:developmentVersionNumber])
                {
                    appVersion = marketingVersionNumber;
                }
                else
                {
                    appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
                }
            }
            else
            {
                appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
            }
            
            NSString *deviceName;
            NSString *OSName;
            NSString *OSVersion;
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            
#if TARGET_OS_IPHONE
            UIDevice *device = [UIDevice currentDevice];
            deviceName = [DeviceUtil hardwareDescription];
            OSName = [device systemName];
            OSVersion = [device systemVersion];
            
#else
            deviceName = @"Macintosh";
            OSName = @"Mac OS X";
            
            OSErr err;
            SInt32 versionMajor, versionMinor, versionBugFix;
            err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
            if (err != noErr) return nil;
            OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
#endif
            
            appVersion = [NSString stringWithFormat:@"%@ %@",appVersion, CCAppState];
            cc_defaultUserAgent = [NSString stringWithFormat:@"%@ %@ (%@; %@ %@; %@)", appName, appVersion, deviceName, OSName, OSVersion, locale];
            
        }
        return cc_defaultUserAgent;
    }
}

@end

@implementation EVNetWorkManager

+ (instancetype)shareInstance
{
    static EVNetWorkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.timeOunt = 60;
    }
    return self;
}

- (NSString *)userAgent
{
    return [ASIHTTPRequest defaultUserAgentString];
}

- (ASIHTTPRequest *)requestWithURLString:(NSString *)urlString
                                   start:(void(^)())startBlock
                                 success:(void(^)(NSData *data))successBlock
                                    fail:(void(^)(NSError *error))failBlock
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    request.timeOutSeconds = self.timeOunt;
    
    [request setStartedBlock:startBlock];
    __weak typeof(request) wrequest = request;
    if ( failBlock )
    {
        [request setFailedBlock:^{
            failBlock(wrequest.error);
        }];
    }
    
    if ( successBlock )
    {
        [request setCompletionBlock:^{
            successBlock(wrequest.responseData);
        }];
    }
    
//    if ( [urlString hasPrefix:@"https"] )
//    {
//        [request setValidatesSecureCertificate:NO];
//    }
    
    [request startAsynchronous];
    return request;
}

- (ASIHTTPRequest *)startSynchronousRequestWIthURLString:(NSString *)urlString
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    request.timeOutSeconds = self.timeOunt;
    [request startSynchronous];
    return request;
}

- (ASIHTTPRequest *)requestWithURLString:(NSString *)urlString
                                 success:(void(^)(NSData *data))successBlock
                                    fail:(void(^)(NSError *error))failBlock
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    request.timeOutSeconds = self.timeOunt;

    __weak typeof(request) wrequest = request;
    if ( failBlock )
    {
        [request setFailedBlock:^{
            failBlock(wrequest.error);
        }];
    }
    
    if ( successBlock )
    {
        [request setCompletionBlock:^{
            successBlock(wrequest.responseData);
        }];
    }
    
//    if ( [urlString hasPrefix:@"https"] )
//    {
//        [request setValidatesSecureCertificate:NO];
//    }
    
    [request startAsynchronous];
    return request;
}

- (ASIHTTPRequest *)requestWithPostData:(NSMutableData *)data
                              urlString:(NSString *)urlString
                                  start:(void(^)())startBlock
                                success:(void(^)(NSData *data))successBlock
                                   fail:(void(^)(NSError *error))failBlock
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    request.postBody  = data;

    request.timeOutSeconds = self.timeOunt;
    __weak typeof(request) wrequest = request;
    if ( failBlock ) {
        [request setFailedBlock:^{
            failBlock(wrequest.error);
        }];
    }
    if ( startBlock )
    {
        [request setStartedBlock:startBlock];
    }
    
    if ( successBlock )
    {
        [request setCompletionBlock:^{
            successBlock(wrequest.responseData);
        }];
    }
    
    [request startAsynchronous];
    return request;
}

- (ASIHTTPRequest *)postRequestWithURLString:(NSString *)urlString
                                  postParams:(NSMutableDictionary *)postParams
                                    fileData:(NSData *)data fileMineType:(NSString *)mineType
                                    fileName:(NSString *)fileName contentType:(NSString *)contentType
                                       start:(void(^)())startBlock success:(void(^)(NSData *data))successBlock
                                        fail:(void(^)(NSError *error))failBlock{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    if ( contentType )
    {
        [request addRequestHeader:@"Content-Type" value:contentType];
    }
    
    if ( postParams.count )
    {
        [postParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    if ( data || fileName || mineType )
    {
        NSAssert(data && fileName && mineType, kE_GlobalZH(@"three_parameter_not_nil"));
        [request setData:data withFileName:fileName andContentType:mineType forKey:@"file"];
    }
    
    request.timeOutSeconds = self.timeOunt;
    
    __weak typeof(request) wrequest = request;
    [request setStartedBlock:startBlock];
    if ( failBlock )
    {
        [request setFailedBlock:^{
            failBlock(wrequest.error);
        }];
    }
    
    if ( successBlock )
    {
        [request setCompletionBlock:^{
            successBlock(wrequest.responseData);
        }];
    }
    
    
    [request startAsynchronous];
    return request;
}

@end
