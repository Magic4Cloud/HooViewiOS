//
//  EVBaseObject.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"
#import "GPJSonModel.h"


@interface EVQueryObject ()

@end

@implementation EVQueryObject

- (instancetype)init
{
    if ( self = [super init] )
    {
        self.start = -1;
        self.count = -1;
    }
    return self;
}

- (NSString *)fmdbQueryStringWithParameterDictionary:(NSDictionary *__autoreleasing *)dictionaryArgs
{
    NSString *tableName = [[EVDB shareInstance] tableNameWithClass:self.clazz];
#ifdef EVDEBUG
    assert(self.properties.count == self.properties_condition_values.count);
    assert(self.properties.count == self.properties_condition_symbol.count);
    assert((NSInteger)self.properties.count - 1 == self.condition_seperator.count);
#endif
    NSMutableString *fmdbQueryString = [NSMutableString string];
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    if ( self.queryColumns.count  )
    {
        [fmdbQueryString appendString:@"SELECT \n"];
        for (NSInteger i = 0; i < self.queryColumns.count; i++)
        {
            NSString *column = self.queryColumns[i];
            NSString *feater = self.queryColumnsFeater[column];
            
            if ( feater )
            {
                [fmdbQueryString appendString:feater];
                [fmdbQueryString appendString:@" "];
            }
            [fmdbQueryString appendString:column];
            
            if ( i < (NSInteger)self.queryColumns.count - 1 )
            {
                [fmdbQueryString appendString:@", "];
            }
            else
            {
                [fmdbQueryString appendString:@"\n"];
            }
        }
        [fmdbQueryString appendString:@"FROM \n"];
    }
    else
    {
        [fmdbQueryString appendString:@"SELECT * FROM \n"];
    }
    
    
    [fmdbQueryString appendString:[NSString stringWithFormat:@"%@ \n", tableName]];
    [fmdbQueryString appendString:@"WHERE \n"];
    
    NSString *propertyName = nil;
    NSInteger count = self.properties.count;
    for (NSInteger i = 0; i < count; i++) {
        propertyName = self.properties[i];
        
        [fmdbQueryString appendString:[NSString stringWithFormat:@"%@ %@ %@ \n",propertyName, self.properties_condition_symbol[i], [NSString stringWithFormat:@":%@",propertyName]]];
        results[propertyName] = self.properties_condition_values[i];
        if ( count > 1 && i < self.condition_seperator.count )
        {
            [fmdbQueryString appendString:self.condition_seperator[i]];
            [fmdbQueryString appendString:@" \n"];
        }
    }
    
    if ( self.tailSql )
    {
        [fmdbQueryString appendFormat:@" %@", self.tailSql];
    }
    
    EVLog(@"query from %@ - %@ - \n%@", tableName, results, fmdbQueryString);
    *dictionaryArgs = results;
    return fmdbQueryString;
}

@end

@implementation EVUpdateSQLObject

@end

@implementation EVBaseObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dict{
    EVBaseObject *obj = [self gp_objectWithDictionary:dict];
    return obj;
}

+ (NSArray *)objectWithData:(NSData *)data{
    return [self gp_objectWithData:data];
}

+ (NSArray *)objectWithDictionaryArray:(NSArray *)dictionaryArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:dictionaryArray.count];
    for (NSDictionary *item in dictionaryArray) {
        [array addObject:[self objectWithDictionary:item]];
    }
    return array;
}

+ (void)updateToLocalWithUpdateObject:(CCUpdateSQLObject *)obj complete:(void (^)())complete
{
    [[EVDB shareInstance] updateToLocalWithUpdateObject:obj complete:complete];
}

+ (void)updateToLocalOnCurrentThreadWithUpdateObject:(CCUpdateSQLObject *)obj
{
    [[EVDB shareInstance] updateToLocalOnCurrentThreadWithUpdateObject:obj];
}

+ (void)queryWithSql:(NSString *)sql complete:(void (^)(FMResultSet *))complete
{
    [[EVDB shareInstance] queryWithSql:sql complete:complete];
}

- (void)updateToLocalCacheOnCurrentThreadWithCondition:(CCQueryObject *)condition
{
    [[EVDB shareInstance] updateCachWithObject:self condition:condition];
}

- (void)updateToLocalCacheWithCondition:(CCQueryObject *)condition complete:(void (^)())complete
{
    [[EVDB shareInstance] updateCachWithObject:self condition:condition complete:complete];
}

- (void)updateToLocalCacheWithProperties:(NSArray *)properties complete:(void (^)())complete
{
    [[EVDB shareInstance] updateCachWithObject:self withProperties:properties complete:complete];
}

- (void)updateToLocalCacheOnCurrentThreadWithProperties:(NSArray *)properties
{
    [[EVDB shareInstance] updateCachOnCurrThreadWithObject:self withProperties:properties];
}

- (void)updateToLocalCacheComplete:(void(^)())complete;
{
    [[EVDB shareInstance] updateCachWithObject:self complete:complete];
}

- (void)deleteFromLocalCacheComplete:(void (^)(EVBaseObject *))complete
{
    [[EVDB shareInstance] deleteCacheWithObject:self complete:complete];
}

+ (NSArray *)queryOnCurrentThreadWithQueryObj:(CCQueryObject *)queryObj
{
    return [[EVDB shareInstance] queryOnCurrThreadWithQueryObject:queryObj];
}

+ (void)cleanTable
{
    [[EVDB shareInstance] cleanTableWithObjectClass:[self class]];
}

+ (void)queryWithQueryObj:(CCQueryObject *)queryObj complete:(void (^)(NSArray *))complete
{
    [[EVDB shareInstance] queryWithQueryObject:queryObj complete:complete];
}

+ (void)queryFromStart:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount complete:(void (^)(NSArray *))complete
{
    [[EVDB shareInstance] queryWithClass:[self class] start:start count:count wholeCount:wholeCount complete:complete];
}

+ (NSArray *)queryOnCurrentThreadFromStart:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount
{
    return [[EVDB shareInstance] queryOnCurrentThreadWithClass:[self class] start:start count:count wholeCount:wholeCount];
}

- (NSMutableDictionary *)objectDictionary
{
    return [self gp_dictionaryFromModel];
}

+ (NSString *)keyColumn
{
    return nil;
}

+ (NSString *)keyColumnType
{
    return nil;
}

+ (NSInteger)tableVersion
{
    return 0;
}

+ (NSDictionary *)ignoreProperties
{
    return nil;
}

+ (NSDictionary *)defalutValueForProperties
{
    return nil;
}

@end
