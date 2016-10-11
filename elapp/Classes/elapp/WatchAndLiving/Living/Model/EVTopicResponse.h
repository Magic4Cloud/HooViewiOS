//
//  EVTopicResponse.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "CCBaseObject.h"

@interface EVTopicResponse : CCBaseObject
/** 当前返回的个数 */
@property (nonatomic,assign) NSInteger count;
/** 纪录下一个start的id */
@property (nonatomic,assign) NSInteger next;
/** 当前请求的start id */
@property (nonatomic,assign) NSInteger start;
/** 返回的话题列表 */
@property (nonatomic,strong) NSMutableArray *topics;
/** 标示是否没有更多的数据用于下拉刷新 */
@property (nonatomic,assign) BOOL noMore;
/** 用于下拉刷新表示当前请求是否正在 请求中 */
@property (nonatomic,assign) BOOL loading;

@end
