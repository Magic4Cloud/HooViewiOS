//
//  EVCacheManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVCacheManager : NSObject

/**
 *  创建一个单例的内存管理对象
 *
 *  @return 管理者的单例
 */
+ (instancetype)shareInstance;

/**
 *  清除硬盘图片缓存
 */
- (void)clearDiskImageCaches;

/**
 *  清除硬盘图片缓存
 *
 *  @param completionBlock 清除完成执行的block
 */
- (void)clearDiskImageCachesWithCompletion:(void(^)())completionBlock;

/**
 *  清除内存图片缓存
 */
- (void)clearMemoryImageCashes;

/**
 *  硬盘上图片缓存所占的大小
 *
 *  @return 硬盘上图片缓存的大小
 */
- (double)imageCachesSizeOnDisk;

/**
 *  清理硬盘图片缓存，不是删除所有图片，只是清除过期的，或者不符合缓存策略的
 */
- (void)cleanDiskImageCaches;

@end
