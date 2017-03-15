//
//  EVVideoTopicItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVBaseObject.h"

@interface EVVideoTopicItem : EVBaseObject

/** 是否选中 */
@property (nonatomic,assign) BOOL isSeclected;
/** 话题id */
@property (nonatomic,copy) NSString *topic_id;
/** 选中话题图标 */
@property (nonatomic,copy) NSString *selecticon;
/** 话题封面 */
@property (nonatomic,copy) NSString *thumb;
/** 超大图标 */
@property (nonatomic,copy) NSString *supericon;
/** 话题描述 */
@property (nonatomic,copy) NSString *topic_description;
/** 话题标题 */
@property (nonatomic,copy) NSString *title;
@property (assign, nonatomic) NSInteger type; /**< 话题的类型（0:normal 1:秀场） */

/** 图标的本地路径 */
@property (nonatomic,copy) NSString *selecticon_imagePath;
/** 超大图标的本地路径 */
@property (nonatomic,copy) NSString *supericon_imagePath;
/** 图标图片 当本地不存在时候返回为空 */
@property (nonatomic,strong) UIImage *selecticon_image;
/** 超大图标的本地路径 当本地不存在时候返回为空 */
@property (nonatomic,strong) UIImage *supericon_image;

@property (nonatomic, assign) NSInteger count;

@property (assign, nonatomic) BOOL isDefault;


@end
