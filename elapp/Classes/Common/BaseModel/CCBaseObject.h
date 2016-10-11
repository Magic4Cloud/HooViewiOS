//
//  CCBaseObject.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVDB.h"

/**
 
 INTEGER，值是有符号整形，根据值的大小以1,2,3,4,6或8字节存放
 REAL，值是浮点型值，以8字节IEEE浮点数存放
 TEXT，值是文本字符串，使用数据库编码（UTF-8，UTF-16BE或者UTF-16LE）存放
 JSON 对于自定义类型请使用 json 字符串
 */

#define COLUMN_TYPE_INTEGER                 @"INTEGER"
#define COLUMN_TYPE_FLOAT                   @"REAL"
#define COLUMN_TYPE_STRING                  @"TEXT"

#define COLUMN_TYPE_JSON                    @"JSON"
#define COLUMN_TYPE_PRIMARY_KEY             @"PRIMARY_KEY"

#define CONDITION_SYMBOL_EQUAL              @"="           // =
#define CONDITION_SYMBOL_MORE               @">"            // >
#define CONDITION_SYMBOL_LESS               @"<"            // <
#define CONDITION_SYMBOL_MORE_EQUAL         @">="       // >=
#define CONDITION_SYMBOL_LESS_EQUAL         @"<="       // <=
#define CONDITION_SYMBOL_NOT_EQUAL          @"!="           // !=

#define CONDITION_AND                       @"AND"
#define CONDITION_OR                        @"OR"
#define CONDITION_LIKE                      @"LIKE"

#define CLUMN_UPDATE_TIME                   @"update_time"

@interface CCQueryObject : NSObject

/**
 *  此属性用于更新或者删除，对于查询无需指定该字段
 */
@property (nonatomic,strong) NSArray *to_update_property_name;

/**
 *  条件对应的属性名字
 *  例如 : select * from table where a = 3;   数组中存的就是 a
 */
@property (nonatomic,strong) NSArray *properties;

/**
 *  条件对应的值
 *  例如 : select * from table where a = 3;   数组中存的就是 @(3)
 */
@property (nonatomic,strong) NSArray *properties_condition_values;

/**
 *  条件的逻辑符号
 *  CONDITION_SYMBOL_EQUAL, CONDITION_SYMBOL_MORE, CONDITION_SYMBOL_LESS, 
 *  CONDITION_SYMBOL_MORE_EQUAL, CONDITION_SYMBOL_LESS_EQUAL, CONDITION_SYMBOL_NOT_EQUAL
 *  例如 : select * from table where a = 3;   数组中存的就是 @(=)
 */
@property (nonatomic,strong) NSArray *properties_condition_symbol;

/**
 *  复合条件的分割符号
 *  例如 : select * from table where a = 3 and b = 4 and c = 5;   数组中存的就是 and ,and
 *  CONDITION_AND, CONDITION_OR, CONDITION_LIKE
 *
 */
@property (nonatomic,strong) NSArray *condition_seperator;

/**
 *  针对哪个类进行查询 ， 必须是 CCBaseObject 子类
 */
@property (nonatomic, assign) Class clazz;

/**
 *  可选 用于查询排序 比如 select * from table where a = 3 order by num asc 
 *  这个属性需要 个的值 是 order by num asc 
 */
@property (nonatomic,copy) NSString *tailSql;

// 以下属性用于分页查询
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic,strong) NSArray *queryColumns;
@property (nonatomic,strong) NSDictionary *queryColumnsFeater;
@property (nonatomic, assign) BOOL notUseDictionaryToModel;

- (NSString *)fmdbQueryStringWithParameterDictionary:(NSDictionary **)dictionaryArgs;

@end

@interface CCUpdateSQLObject : NSObject

/**
 *  键值对 - 要更新的 列名 － 列值
 */
@property (nonatomic,strong) NSDictionary *propertyKeyValues;

/**
 *  针对哪个类进行查询 ， 必须是 CCBaseObject 子类
 */
@property (nonatomic, assign) Class clazz;

/**
 *  可选 用于查询排序 比如 update table set a = 3 where b = 4
 *  这个属性需要 个的值 是 where b = 4
 */
@property (nonatomic,copy) NSString *tailSql;

// 以下是接条件的
/**
 *  条件对应的属性名字
 *  例如 : select * from table where a = 3;   数组中存的就是 a
 */
@property (nonatomic,strong) NSArray *properties;

/**
 *  条件对应的值
 *  例如 : select * from table where a = 3;   数组中存的就是 @(3)
 */
@property (nonatomic,strong) NSArray *properties_condition_values;

/**
 *  条件的逻辑符号
 *  CONDITION_SYMBOL_EQUAL, CONDITION_SYMBOL_MORE, CONDITION_SYMBOL_LESS,
 *  CONDITION_SYMBOL_MORE_EQUAL, CONDITION_SYMBOL_LESS_EQUAL, CONDITION_SYMBOL_NOT_EQUAL
 *  例如 : select * from table where a = 3;   数组中存的就是 @(=)
 */
@property (nonatomic,strong) NSArray *properties_condition_symbol;

/**
 *  复合条件的分割符号
 *  例如 : select * from table where a = 3 and b = 4 and c = 5;   数组中存的就是 and ,and
 *  CONDITION_AND, CONDITION_OR, CONDITION_LIKE
 *
 */
@property (nonatomic,strong) NSArray *condition_seperator;

@end

@interface CCBaseObject : NSObject

//@property (nonatomic,strong) NSDictionary *inialDictionary;

+ (instancetype)objectWithDictionary:(NSDictionary *)dict;

+ (NSArray *)objectWithData:(NSData *)data;

+ (NSArray *)objectWithDictionaryArray:(NSArray *)dictionaryArray;

- (NSMutableDictionary *)objectDictionary;

//@property (nonatomic,strong) NSMutableDictionary *objectJSONDictionary;

// 子类如果想使用数据缓存必须实现以下方法
/**

   INTEGER，值是有符号整形，根据值的大小以1,2,3,4,6或8字节存放
   REAL，值是浮点型值，以8字节IEEE浮点数存放
   TEXT，值是文本字符串，使用数据库编码（UTF-8，UTF-16BE或者UTF-16LE）存放
   JSON 对于自定义类型请使用 json 字符串
 */


/**
 *  子类必须实现该方法来唯一字段，以防重复插入
 *
 *  @return 唯一标示该键
 */
+ (NSString *)keyColumn;

/**
 *  主键的类型 必须为 COLUMN_TYPE_INTEGER  ，COLUMN_TYPE_STRING 
 *
 *  @return 
 */
+ (NSString *)keyColumnType;

/**
 *  表的版本号，用于版本适配,如果 columns 有改变的时候必须 += 1
 *
 *  @return 表的版本号
 */
+ (NSInteger)tableVersion;

/**
 *  用于忽略一些没有的属性不会插入到数据库,注意除了基本数据类型，NSString NSArray NSMutableArray NSDictionary NSMutableDictionary 外其他都要 ingore
 *
 *  @return 
 */
+ (NSDictionary *)ignoreProperties;

/**
 *  插入数据库时候给某些属性一些默认值
 *
 *  @return 
 */
+ (NSDictionary *)defalutValueForProperties;

// 插入数据库时候给某些属性一些默认值 keyColumn ，keyColumnType ，tableVersion

/**
 *  根据条件进行更新数据库
 *
 *  @param complete
 */
+ (void)updateToLocalWithUpdateObject:(CCUpdateSQLObject *)obj complete:(void(^)())complete;

///**
// *  条件更新
// *
// *  @param obj
// *  @param complete 
// */
//+ (void)updateToLocalWithUpdateObject:(CCUpdateSQLObject *)obj complete:(void (^)())complete;

/**
 *  在当前线程中进行更新
 *
 *  @param obj 
 */
+ (void)updateToLocalOnCurrentThreadWithUpdateObject:(CCUpdateSQLObject *)obj;

/**
 *  把当前对象插入或者更新本地数据库 异步 主键必须有值
 *
 *  @param complete 完成的回调
 */
- (void)updateToLocalCacheComplete:(void(^)())complete;

/**
 *  异步更新相应的属性值到本地数据库中 - 主键必须有值
 *
 *  @param properties 属性值
 *  @param complete   回调
 */
- (void)updateToLocalCacheWithProperties:(NSArray *)properties complete:(void(^)())complete;

/**
 * 同步更新到本地数据库中 会阻塞当前线程 - 主键必须有值
 *
 *  @param properties
 */
- (void)updateToLocalCacheOnCurrentThreadWithProperties:(NSArray *)properties;

/**
 *  指定条件同步更新数据到数据库中 － 同步
 *
 *  @param condition 指定的条件
 */
- (void)updateToLocalCacheOnCurrentThreadWithCondition:(CCQueryObject *)condition;

/**
 *  指定条件更新数据到数据库中 － 异步
 *
 *  @param condition 条件描述对象
 *  @param complete  回调
 */
- (void)updateToLocalCacheWithCondition:(CCQueryObject *)condition complete:(void(^)())complete;

///**
// *  插入到本地数据库中, 同步 可能会阻塞当前线程
// */
//- (void)updateToLocalCacheOnCurrentThread;

/**
 *  从本地缓存删除该记录 keyColumn 对应的属性值必须不为空
 *
 *  @param complete 完成的回调
 */
- (void)deleteFromLocalCacheComplete:(void (^)(CCBaseObject *))complete;

/**
 *  清空当前类所对应的表
 */
+ (void)cleanTable;

/**
 *  在当前线程中执行查询,如果在主线程中执行可能会阻塞主线程
 *
 *  @param queryObj
 *
 *  @return 
 */
+ (NSArray *)queryOnCurrentThreadWithQueryObj:(CCQueryObject *)queryObj;

/**
 *  根据查询对象进行查询
 *
 *  @param queryObj
 *  @param complete 
 */
+ (void)queryWithQueryObj:(CCQueryObject *)queryObj complete:(void (^)(NSArray *))complete;

/**
 *  下拉刷新查询
 *
 *  @param clazz      目标对象类型
 *  @param start      开始的脚标 如果上一次查询 count ＝ 5 ，这次查询 start ＝ 5
 *  @param count      要查询的个数，
 *  @param wholeCount 通过指针返回当前表的总个数
 *  @param complete   查询完的回调，如果传 nil 将会不做任何操作
 */
+ (void)queryFromStart:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount complete:(void(^)(NSArray *items))complete;

/**
 *  下拉刷新 － 同步执行
 *
 *  @param start
 *  @param count
 *  @param wholeCount
 *
 *  @return 
 */
+ (NSArray *)queryOnCurrentThreadFromStart:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount;

+ (void)queryWithSql:(NSString *)sql complete:(void(^)(FMResultSet *result))complete;

@end
