//
//  EVAudioOnlyCollectionViewCellItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>

#define INVALID_BGPID -1

@interface EVAudioOnlyCollectionViewCellItem : NSObject

/** 图片 id ,id = -1 为 本地默认的图片 */
@property (nonatomic, assign) NSInteger bgpid;

/** 图片 */
@property (nonatomic,strong) UIImage *image;

/** 是否选中 ui */
@property (nonatomic, assign) BOOL selected;

@end
