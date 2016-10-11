//
//  EVDB.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@class CCBaseObject, CCQueryObject, CCUpdateSQLObject;

// 使用该类时候，模型必须继承于 CCBaseObject
@interface EVDB : NSObject

+ (instancetype)shareInstance;

/**
 *  插入纪录或者修改纪录
 *
 *  @param obj
 */
- (void)updateCachWithObject:(CCBaseObject *)obj complete:(void(^)())complete;

/**
 *  条件更新 － 同步
 *
 *  @param obj
 */
- (void)updateToLocalOnCurrentThreadWithUpdateObject:(CCUpdateSQLObject *)obj;

/**
 *  条件更新 - 异步
 *
 *  @param obj
 *  @param complete
 */
- (void)updateToLocalWithUpdateObject:(CCUpdateSQLObject *)obj complete:(void (^)())complete;

/**
 *  异步更新某些列会根据 properties 来进行更新相应的列值
 *
 *  @param obj
 *  @param array 
 */
- (void)updateCachWithObject:(CCBaseObject *)obj withProperties:(NSArray *)properties complete:(void(^)())complete;

/**
 *  根据给定的条件进行数据插入 － 异步
 *
 *  @param obj
 *  @param properties
 *  @param condition
 *  @param complete
 */
- (void)updateCachWithObject:(CCBaseObject *)obj condition:(CCQueryObject *)condition complete:(void(^)())complete;

/**
 *  根据给定的条件进行数据插入 － 同步
 *
 *  @param obj
 *  @param properties
 *  @param condition
 */

- (void)updateCachWithObject:(CCBaseObject *)obj condition:(CCQueryObject *)condition;

/**
 *  同步更新某些列会根据 properties 来进行更新相应的列值
 *
 *  @param obj
 *  @param array
 */
- (void)updateCachOnCurrThreadWithObject:(CCBaseObject *)obj withProperties:(NSArray *)properties;

/**
 *  在当前线程中进行插入操作
 *
 *  @param obj 
 */
- (void)updateCachOnCurrThreadWithObject:(CCBaseObject *)obj;

/**
 *  删除缓存中的纪录
 *
 *  @param obj 
 */
- (void)deleteCacheWithObject:(CCBaseObject *)obj complete:(void(^)(CCBaseObject *obj))complete;

/**
 *  清空改对象对应的表的所有数据
 *
 *  @param object
 */
- (void)cleanTableWithObjectClass:(Class)clazz;

/**
 *  根据给定的查询对象进行查询
 *
 *  @param complete 查询结束回调
 */
- (void)queryWithQueryObject:(CCQueryObject *)queryObj complete:(void (^)(NSArray *))complete;

/**
 *  同步查询
 *
 *  @param queryObj 
 */
- (NSArray *)queryOnCurrThreadWithQueryObject:(CCQueryObject *)queryObj;

/**
 *  根据给定的类型进行下拉刷新查询
 *
 *  @param clazz      目标对象类型
 *  @param start      开始的脚标 如果上一次查询 count ＝ 5 ，这次查询 start ＝ 5
 *  @param count      要查询的个数，
 *  @param wholeCount 通过指针返回当前表的总个数
 *  @param complete   查询完的回调，如果传 nil 将会不做任何操作
 */
- (void)queryWithClass:(Class)clazz start:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount complete:(void(^)(NSArray *items))complete;

/**
 *  根据给定的类型进行下拉刷新查询 － 同步
 *
 *  @param clazz
 *  @param start
 *  @param count
 *  @param wholeCount
 */
- (NSArray *)queryOnCurrentThreadWithClass:(Class)clazz start:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount;

/**
 *  初始化数据引擎
 */
- (void)prepare;

/**
 *  根据类获取缓存中的表名
 *
 *  @param clazz 必须为 CCBaseObject 子类
 *
 *  @return 表名
 */
- (NSString *)tableNameWithClass:(Class)clazz;

- (void)beginTransation;

- (void)endTranstaction;

- (void)queryWithSql:(NSString *)sql complete:(void(^)(FMResultSet *rs))complete;

@end
