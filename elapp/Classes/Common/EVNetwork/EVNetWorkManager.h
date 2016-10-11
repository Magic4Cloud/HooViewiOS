//
//  EVNetWorkManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, CCNetWorkHTTPMethod) {
    CCNetWorkHTTPMethodGet,
    CCNetWorkHTTPMethodPost
};

@interface EVNetWorkRequest : NSObject

@property (nonatomic, copy) NSString *urlString;
/** key:String value:String  */
@property (nonatomic, strong) NSDictionary *getParams;
/** key:String value:String -> 此参数用于 POST 请求 */
@property (nonatomic, strong) NSData *postData;
/** 默认为 GET */
@property (nonatomic, assign) CCNetWorkHTTPMethod httpMethod;
- (instancetype)initWithURLString:(NSString *)urlString;

+ (instancetype)netWorkRequestURLString:(NSString *)urlString;

@end

@interface EVNetWorkManager : NSObject

/** 超时时间 */
@property (nonatomic, assign) NSTimeInterval timeOunt;

@property (nonatomic,strong, readonly) NSString *userAgent;

+ (instancetype)shareInstance;

- (ASIHTTPRequest *)requestWithURLString:(NSString *)urlString success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;

- (ASIHTTPRequest *)startSynchronousRequestWIthURLString:(NSString *)urlString;

- (ASIHTTPRequest *)requestWithURLString:(NSString *)urlString start:(void(^)())startBlock success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;

- (ASIHTTPRequest *)postRequestWithURLString:(NSString *)urlString postParams:(NSMutableDictionary *)postParams fileData:(NSData *)data fileMineType:(NSString *)mineType fileName:(NSString *)fileName contentType:(NSString *)contentType start:(void(^)())startBlock success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;

- (ASIHTTPRequest *)requestWithPostData:(NSMutableData *)data urlString:(NSString *)urlString start:(void(^)())startBlock success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;

@end
