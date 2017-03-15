//
//  EVTopicItem.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

@interface EVTopicItem : EVBaseObject
/**话题id*/
@property (nonatomic, copy) NSString *Id;
/**标题*/
@property(nonatomic,copy)NSString *title;
/**图标*/
@property(nonatomic,copy)NSString *icon;
/**话题背景图片*/
@property (nonatomic,copy)NSString *thumb;
/**描述信息*/
@property (nonatomic,copy)NSString *descriptions;
/**是否选中*/
@property (nonatomic,assign) BOOL selected;

@end
