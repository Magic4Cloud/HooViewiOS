//
//  EVCacheManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCacheManager.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>

#define MAX_IMAGE_CACHESIZE ( 100 * 1024 * 1024 )

@implementation EVCacheManager

#pragma mark - public class methods

+ (instancetype)shareInstance
{
    static EVCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EVCacheManager alloc] init];
    });
    
    return manager;
}


#pragma mark - public instance methods

- (void)clearDiskImageCaches
{
    // 清除SDWebImage在disk上缓存的图片
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)clearDiskImageCachesWithCompletion:(void(^)())completionBlock
{
    // 清除SDWebImage在disk上缓存的图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completionBlock];
}

- (void)clearMemoryImageCashes
{
    // 清除内存中SDWebImage缓存的图片
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 取消SDWebImage所有加载图片的网络请求
    [[SDWebImageManager sharedManager] cancelAll];
}

- (double)imageCachesSizeOnDisk
{
    double tmpSize = [[SDImageCache sharedImageCache] getSize];
    double size = tmpSize / 1024.0 / 1024.0;
    return size;
}

- (void)cleanDiskImageCaches
{
    // 清理SDWebImage在disk上缓存的图片
    if ( [[SDImageCache sharedImageCache] getSize] > MAX_IMAGE_CACHESIZE )
    {
        [[SDImageCache sharedImageCache] cleanDisk];
    }
}


#pragma mark - get image caches size

- (CGFloat)checkDiskImageCacheSize
{
    /*
    float totalSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    } // NSLog(@"tmp size is %.2f",totalSize);
    return totalSize;
     */
    return 0;
}

@end
