//
//  EVNetWorkManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, EVNetWorkHTTPMethod) {
    EVNetWorkHTTPMethodGet,
    EVNetWorkHTTPMethodPost
};

@interface EVNetWorkRequest : NSObject

@property (nonatomic, copy) NSString *urlString;
/** key:String value:String  */
@property (nonatomic, strong) NSDictionary *getParams;
/** key:String value:String -> 此参数用于 POST 请求 */
@property (nonatomic, strong) NSData *postData;
/** 默认为 GET */
@property (nonatomic, assign) EVNetWorkHTTPMethod httpMethod;
- (instancetype)initWithURLString:(NSString *)urlString;

+ (instancetype)netWorkRequestURLString:(NSString *)urlString;

@end

@interface EVNetWorkManager : NSObject

/** 超时时间 */
@property (nonatomic, assign) NSTimeInterval timeOunt;

@property (nonatomic,strong, readonly) NSString *userAgent;

+ (instancetype)shareInstance;


@end
