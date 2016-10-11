//
//  EVOpenURLManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//进行网络请求判断
#import <Foundation/Foundation.h>

@interface EVOpenURLManager : NSObject

/**
 *  单例初始化网络请求
 */
+ (instancetype)shareInstance;

/**
 *  进行网络请求
 *
 *  @param url 请求地址
 *
 *  @return 是否可以进行请求，YES可以，NO不可以
 */
- (BOOL)openUrl:(NSURL *)url;

@end
