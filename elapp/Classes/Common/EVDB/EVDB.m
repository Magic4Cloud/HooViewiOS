//
//  EVDB.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVDB.h"
#import "EVBaseObject.h"
#import "GPJSonModel.h"
#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"
#import "NSString+Extension.h"
#import "NSObject+Extension.h"


#define CLASS_NAME  @"class_name"
#define VERSION     @"version"
#define TABLE_NAME  @"table_name"

#define MANAGE_TABLE            @"t_manage_table"

#define CLEAN_TIME_SPAN         (7 * 24 * 60 * 60)

@interface EVDB ()
{
    FMDatabase              *_db;
    dispatch_queue_t        _db_queue;
}

@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) NSMutableArray *tables;

@end

@implementation EVDB

static NSMutableDictionary *_sqliteDictionary = nil;
+ (void)initialize
{
    _sqliteDictionary = [NSMutableDictionary dictionary];
}

- (void)updateToLocalWithUpdateObject:(CCUpdateSQLObject *)obj complete:(void (^)())complete
{
    dispatch_async(_db_queue, ^{
        [self updateToLocalOnCurrentThreadWithUpdateObject:obj];
        if ( complete )
        {
            complete();
        }
    });
}

- (void)updateToLocalOnCurrentThreadWithUpdateObject:(CCUpdateSQLObject *)obj
{
    [self _updateToLocalOnCurrentThreadWithUpdateObject:obj];
}

- (void)updateCachWithObject:(EVBaseObject *)obj condition:(CCQueryObject *)condition complete:(void (^)())complete
{
    dispatch_async(_db_queue, ^{
        [self updateCachWithObject:obj condition:condition];
        if ( complete )
        {
            complete();
        }
    });
}

- (void)queryWithSql:(NSString *)sql complete:(void (^)(FMResultSet *))complete
{
    dispatch_async(_db_queue, ^{
        FMResultSet *rs = [_db executeQuery:sql];
        [self performBlockOnMainThread:^{
            if ( complete )
            {
                complete(rs);
            }
        }];
    });
}

- (void)updateCachWithObject:(EVBaseObject *)obj condition:(CCQueryObject *)condition
{
    [self checkObject:obj];
    [self _updateWithObject:obj condition:condition];
}

- (void)updateCachWithObject:(EVBaseObject *)obj withProperties:(NSArray *)properties complete:(void (^)())complete
{
    dispatch_async(_db_queue, ^{
        [self updateToTableWithObject:obj withProperties:properties];
        if ( complete )
        {
            [self performBlockOnMainThread:^{
                complete();
            }];
        }
    });
}

- (void)beginTransation
{
    [_db beginTransaction];
}

- (void)endTranstaction
{
    [_db commit];
}

- (void)updateCachOnCurrThreadWithObject:(EVBaseObject *)obj withProperties:(NSArray *)properties
{
    [self checkObject:obj];
    [self updateToTableWithObject:obj withProperties:properties];
}

#pragma mark - public method
- (void)updateCachWithObject:(EVBaseObject *)obj complete:(void(^)())complete
{
    dispatch_async(_db_queue, ^{
        [self _updateCachWithObject:obj];
        if ( complete )
        {
            [self performBlockOnMainThread:^{
                complete();
            }];
        }
    });
}

- (void)updateCachOnCurrThreadWithObject:(EVBaseObject *)obj
{
    [self _updateCachWithObject:obj];
}

- (void)prepare
{
    dispatch_async(_db_queue, ^{
        [self _prepare];
    });
}

- (void)deleteCacheWithObject:(EVBaseObject *)obj complete:(void (^)(EVBaseObject *))complete
{
    dispatch_async(_db_queue, ^{
        [self _deleteCacheWithObject:obj];
        if ( complete )
        {
            [self performBlockOnMainThread:^{
                complete(obj);
            }];
        }
    });
}

- (void)cleanTableWithObjectClass:(Class)clazz
{
    dispatch_async(_db_queue, ^{
        [self _cleanTableWithObjectClass:clazz];
    });
}


- (void)queryWithQueryObject:(CCQueryObject *)queryObj complete:(void (^)(NSArray *))complete
{
    if ( complete == nil )
    {
        return;
    }
    
    dispatch_async(_db_queue, ^{
        NSArray *obj = [self _queryWithQueryObject:(EVQueryObject *)queryObj];
        [self performBlockOnMainThread:^{
            complete(obj);
        }];
    });
}

- (NSArray *)queryOnCurrThreadWithQueryObject:(CCQueryObject *)queryObj
{
    return [self _queryWithQueryObject:(EVQueryObject *)queryObj];
}

- (void)queryWithClass:(Class)clazz start:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount complete:(void (^)(NSArray *))complete
{
    if ( complete == nil )
    {
        return;
    }
#ifdef EVDEBUG
    assert([clazz isSubclassOfClass:[EVBaseObject class]]);
#endif
    
    dispatch_async(_db_queue, ^{
         NSArray *items = [self _queryWithClass:clazz start:start count:count wholeCount:wholeCount];
        [self performBlockOnMainThread:^{
            complete(items);
        }];
    });
    
}

- (NSArray *)queryOnCurrentThreadWithClass:(Class)clazz start:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount
{
    return [self _queryWithClass:clazz start:start count:count wholeCount:wholeCount];
}

// SELECT * FROM t_CCNowVideoItem LIMIT 10, 100
#pragma mark - private
- (void)_updateToLocalOnCurrentThreadWithUpdateObject:(EVUpdateSQLObject *)obj
{
    NSString *tableName = [self tableNameWithClass:obj.clazz];
    NSMutableString *fmdbSql = [NSMutableString string];
    [fmdbSql appendFormat:@"UPDATE %@ SET \n", tableName];
#ifdef EVDEBUG
    assert(obj.propertyKeyValues.count);
    
    if ( obj.properties.count )
    {
        assert(obj.properties.count == obj.properties_condition_symbol.count);
        assert(obj.properties.count == obj.properties_condition_values.count);
        assert(obj.properties.count == obj.condition_seperator.count + 1);
    }
    
#endif
    NSInteger count = obj.propertyKeyValues.count;
    __block NSInteger index = 0;
    NSMutableArray *values = [NSMutableArray array];
    [obj.propertyKeyValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [fmdbSql appendFormat:@"%@ = :%@ ", key, key];
        if ( index < count - 1 )
        {
            [fmdbSql appendString:@", "];
        }
        [values addObject:value];
        [fmdbSql appendString:@" \n"];
        index++;
    }];
    
    if ( !obj.propertyKeyValues[CLUMN_UPDATE_TIME] )
    {
        [fmdbSql appendString:@", "];
        [fmdbSql appendFormat:@"%@ = ? \n", CLUMN_UPDATE_TIME];
        [values addObject:@([[NSDate date] timeIntervalSince1970])];
    }
    
    if ( obj.properties.count )
    {
       [fmdbSql appendString:@"WHERE \n"];
        NSString *propertyName = nil;
        NSString *seperator = nil;
        for (NSInteger i = 0; i < obj.properties.count; i++)
        {
            propertyName = obj.properties[i];
            seperator = obj.properties_condition_symbol[i];
            [fmdbSql appendFormat:@"%@ %@ :%@ \n",propertyName ,seperator ,propertyName];
            [values addObject:obj.properties_condition_values[i]];
            
            if ( obj.properties.count > 0 && i < (NSInteger)obj.properties.count - 1 )
            {
                [fmdbSql appendString:obj.condition_seperator[i]];
                [fmdbSql appendString:@"\n"];
            }
            
            propertyName = nil;
            seperator = nil;
        }
    }
    
    if ( obj.tailSql )
    {
        [fmdbSql appendString:obj.tailSql];   
    }
    
    EVLog(@"---%@", fmdbSql);
    if ( ![_db executeUpdate:fmdbSql withArgumentsInArray:values] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    
}

- (void)_updateWithObject:(EVBaseObject *)obj condition:(EVQueryObject *)queryObj
{
#ifdef EVDEBUG
    assert(queryObj.properties.count == queryObj.properties_condition_values.count);
    assert(queryObj.properties.count == queryObj.properties_condition_symbol.count);
    assert((NSInteger)queryObj.properties.count -1 == queryObj.condition_seperator.count);
    assert(queryObj.to_update_property_name.count);
#endif
    NSMutableString *fmdbSql = [NSMutableString string];
    NSString *tableName = [self tableNameWithClass:[obj class]];
    
    [fmdbSql appendFormat:@"UPDATE %@ \n", tableName];
    [fmdbSql appendString:@"SET \n"];
    
    NSInteger count = queryObj.to_update_property_name.count;
    NSString *item = nil;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:queryObj.to_update_property_name.count];
    for (NSInteger i = 0; i < count; i++)
    {
        item = queryObj.to_update_property_name[i];
        [fmdbSql appendFormat:@"%@ = ?", item];
        id value = nil;
        
        if ( [item isEqualToString:CLUMN_UPDATE_TIME] )
        {
            value = @(MAXFLOAT);
        }
        else
        {
            if ( ( value = [obj valueForKeyPath:item] ) == nil )
            {
                value = [[NSNull alloc] init];
            }
        }
        
        [values addObject:value];
        if ( i < count - 1 )
        {
            [fmdbSql appendString:@", \n"];
        }
    }
    
    if ( ![queryObj.properties containsObject:CLUMN_UPDATE_TIME] )
    {
        [fmdbSql appendString:@", "];
        [fmdbSql appendFormat:@"%@ = ? \n", CLUMN_UPDATE_TIME];
        [values addObject:@([[NSDate date] timeIntervalSince1970])];
    }

    [fmdbSql appendString:@"WHERE \n"];
    
    count = queryObj.properties.count;
    item = nil;
    NSString *symbol = nil;
    NSString *seperator = nil;
    for (NSInteger i = 0; i < count; i++)
    {
        item = queryObj.properties[i];
        symbol = queryObj.properties_condition_symbol[i];
        
        id value = queryObj.properties_condition_values[i];
        [values addObject:value];
        
        if ( count > 0 && i < count - 1 )
        {
            seperator = queryObj.condition_seperator[i];
        }
        
        [fmdbSql appendFormat:@"%@ %@ ? \n", item, symbol];
        
        if ( seperator )
        {
            [fmdbSql appendFormat:@"%@ \n", seperator];
        }
        
        seperator = nil;
    }
    
    if ( ![_db executeUpdate:fmdbSql withArgumentsInArray:values] ) {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    
    EVLog(@"update to table - \n %@ \n %@", queryObj.properties ,fmdbSql);
}

- (void)_executeSql:(NSString *)sql
{
    
}

- (NSArray *)_queryWithClass:(Class)clazz start:(NSInteger)start count:(NSInteger)count wholeCount:(NSInteger *)wholeCount
{
    NSString *tableName = [self tableNameWithClass:clazz];
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT count(*) FROM %@", tableName];
    FMResultSet *rs = [_db executeQuery:sql];
    EVLog(@"query - \n %@",sql);
    
    if ( ![rs next] )
    {
        [rs close];
        return nil;
    }
    
    NSInteger counts = [rs intForColumn:0];
    if ( wholeCount )
    {
        *wholeCount = counts;
    }
    [rs close];
    
    sql = [NSMutableString string];
    [sql appendString:@"SELECT * FROM \n"];
    [sql appendFormat:@"%@ \n", tableName];
    [sql appendFormat:@"LIMIT %ld, %ld", start, start + count];
    
    EVLog(@"-------%lf",[[NSDate date] timeIntervalSince1970]);
    rs = [_db executeQuery:sql];
    
    NSMutableArray *result = [NSMutableArray array];
    EVBaseObject *obj = nil;
    while ( [rs next] )
    {
        if ( (obj = [self _objectDictionarWithResultSet:rs fromClass:clazz]) )
        {
            [result addObject:obj];
        }
        obj = nil;
    }
    EVLog(@"-------%lf",[[NSDate date] timeIntervalSince1970]);
    return result;
}

- (NSArray *)_queryWithQueryObject:(EVQueryObject *)queryObj
{
    NSString *tableName = [self tableNameWithClass:queryObj.clazz];
    if ( ![[self currentTable] containsObject:tableName] )
    {
        return nil;
    }
    
    NSString *fmdbSql = nil;
    NSDictionary *dictionaryArgs = nil;
    
    if ( queryObj.properties == nil || queryObj.properties_condition_values == nil || queryObj.properties_condition_symbol == nil )
    {
        fmdbSql = [NSString stringWithFormat:@"\nSELECT * FROM %@ \n", tableName];
        
        if ( queryObj.tailSql )
        {
            fmdbSql = [NSString stringWithFormat:@"%@ %@", fmdbSql, queryObj.tailSql];
        }
    }
    else
    {
        fmdbSql = [queryObj fmdbQueryStringWithParameterDictionary:&dictionaryArgs];
    }
    
//    if ( queryObj.tailSql )
//    {
//        fmdbSql = [NSString stringWithFormat:@"%@ \n %@ ", fmdbSql, queryObj.tailSql];
//    }
    
    if ( queryObj.count >0 && queryObj.start >= 0 )
    {
        fmdbSql = [NSString stringWithFormat:@"%@ \n LIMIT %ld ,%ld", fmdbSql, queryObj.start, queryObj.count];
    }
    
    EVLog(@"fmdbsql - %@", fmdbSql);
    FMResultSet *rs = nil;
    if ( dictionaryArgs ) {
        rs = [_db executeQuery:fmdbSql withParameterDictionary:dictionaryArgs];
    }
    else
    {
        rs = [_db executeQuery:fmdbSql];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    
    NSMutableArray *resulstDicts = [NSMutableArray array];
    if ( queryObj.notUseDictionaryToModel )
    {
#ifdef EVDEBUG
        assert(queryObj.queryColumns.count);
#endif
        for (NSString *column in queryObj.queryColumns)
        {
            NSMutableArray *list = [NSMutableArray array];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[column] = list;
            [resulstDicts addObject:dict];
        }
    }
    
    
    while ( [rs next] )
    {
        if ( !queryObj.notUseDictionaryToModel )
        {
            [result addObject:[self _objectDictionarWithResultSet:rs fromClass:queryObj.clazz]];
        }
        else
        {
            for (NSMutableDictionary *item in resulstDicts)
            {
               NSString *column = [[item allKeys] lastObject];
                NSMutableArray *itemArray = item[column];
                [itemArray addObject:[rs objectForColumnName:column]];
            }
        }
    }
    [rs close];
    
    return result.count ? result : resulstDicts;
}

- (EVBaseObject *)_queryWithClass:(Class)clazz withKeyValues:(NSDictionary *)keyValues condictions:(NSDictionary *)condictions
{
//    [db executeQuery:@"select * from namedparamcounttest where a = :a" withParameterDictionary:dictionaryArgs];
    NSString *tableName = [self tableNameWithClass:clazz];
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT * FROM \n"];
    [sql appendFormat:@"%@ \n",tableName];
    
    [sql appendString:[NSString stringWithFormat:@"WHERE \n"]];
    
    [_db executeQuery:sql withParameterDictionary:keyValues];
    
    EVLog(@"query - \n %@", sql);
    return [self objectDictionarWithResultSet:[_db executeQuery:sql] fromClass:clazz];
}

- (EVBaseObject *)_queryWithClass:(Class)clazz withKeyColumnValue:(id)value
{
    NSString *keyColumn = [clazz keyColumn];
    NSString *keyColumnType = [clazz keyColumnType];
    NSString *tableName = [self tableNameWithClass:clazz];
#ifdef EVDEBUG
    assert(keyColumn);
    assert(keyColumnType);
    assert(value);
#endif
    
    if ( ![[self currentTable] containsObject:tableName] ) return nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT * FROM \n"];
    [sql appendFormat:@"%@ \n",tableName];
    NSString *condiction = [NSString stringWithFormat:@"%@", value];;
    if ( [keyColumnType isEqualToString:COLUMN_TYPE_STRING] )
    {
        condiction = [NSString stringWithFormat:@"%@ = '%@' \n", keyColumn, value];
    }
    else if ( [keyColumnType isEqualToString:COLUMN_TYPE_INTEGER] )
    {
        condiction = [NSString stringWithFormat:@"%@ = %@ \n" ,keyColumn, value];
    }
    else
    {
#ifdef EVDEBUG
        assert(0);
#endif
        return nil;
    }
    [sql appendString:[NSString stringWithFormat:@"WHERE \n"]];
    [sql appendString:condiction];
    
    EVLog(@"query - \n %@", sql);
    
    return [self objectDictionarWithResultSet:[_db executeQuery:sql] fromClass:clazz];
}

- (void)_cleanTableWithObjectClass:(Class)clazz
{
    NSString *tableName = [self tableNameWithClass:clazz];
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"DELETE FROM %@ \n", tableName];
    if ( ![_db executeUpdate:string] ) {
//#ifdef EVDEBUG
//        assert(0);
//#endif
    }
    EVLog(@"%@", string);
}

- (void)_deleteCacheWithObject:(EVBaseObject *)obj
{
    NSString *keyColumn = [[obj class] keyColumn];
    NSString *keyColumnType = [[obj class] keyColumnType];
    id value = [obj valueForKeyPath:keyColumn];
    
    if (  value == nil  )
    {
        return;
    }
    
#ifdef EVDEBUG
    assert(keyColumn);
    assert(keyColumnType);
    assert(value);
#endif
    NSString *table_name = [self tableNameWithClass:[obj class]];
    // DELETE FROM t_CCNowVideoItem WHERE vid = '2Mq4C4e1hBZl'
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"DELETE FROM \n"];
    [sql appendString:[NSString stringWithFormat:@"%@ \n",table_name]];
    NSString *condition = nil;
    if ( [keyColumnType isEqualToString:COLUMN_TYPE_STRING] )
    {
        condition = [NSString stringWithFormat:@"WHERE %@ = '%@'", keyColumn, [NSString stringWithFormat:@"%@",value]];
    }
    else if ( [keyColumnType isEqualToString:COLUMN_TYPE_FLOAT] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    else if ( [keyColumnType isEqualToString:COLUMN_TYPE_INTEGER] )
    {
        condition = [NSString stringWithFormat:@"WHERE %@ = %ld", keyColumn, (long)[value integerValue]];
    }
    
#ifdef EVDEBUG
         assert(condition);
#endif
    if ( condition )
    {
        [sql appendString:condition];
    }
         
    if ( ![_db executeUpdate:sql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    EVLog(@"delete cache - \n%@",sql);
}

- (void)_updateCachWithObject:(EVBaseObject *)obj andProperties:(NSArray *)properties
{
    [self checkObject:obj];
    [self updateToTableWithObject:obj withProperties:properties];
}

- (void)_updateCachWithObject:(EVBaseObject *)obj
{
    [self checkObject:obj];
    [self updateToTableWithObject:obj];
}

- (void)updateToTableWithObject:(EVBaseObject *)obj withProperties:(NSArray *)properties
{
    NSString *tableName = [self tableNameWithClass:[obj class]];
    NSString *keyColumn = [[obj class] keyColumn];
    NSMutableString *fmdbSql = [NSMutableString string];
    NSMutableString *tailSql = [NSMutableString string];
    [fmdbSql appendFormat:@"INSERT OR REPLACE INTO %@ \n", tableName];
    [fmdbSql appendString:@"(\n"];
    [tailSql appendString:@"("];
    NSInteger count = properties.count;
    NSString *item = nil;
     NSMutableArray *values = [NSMutableArray arrayWithCapacity:properties.count];
    for (NSInteger i = 0; i < count; i++)
    {
        item = properties[i];
        [fmdbSql appendFormat:@"%@", item];
        [tailSql appendString:@"?"];
        id value = nil;
        
        if ( [item isEqualToString:CLUMN_UPDATE_TIME] )
        {
            value = @(MAXFLOAT);
        }
        else
        {
            if ( ( value = [obj valueForKeyPath:item] ) == nil )
            {
                if ( [item isEqualToString:keyColumn]  )
                {
#ifdef EVDEBUG
                    assert(0);
#endif
                }
                
                value = [[NSNull alloc] init];
            }
            
        }
        
        [values addObject:value];
        if ( i < count - 1 )
        {
            [fmdbSql appendString:@", "];
            [tailSql appendString:@", "];
        }
    }
    if ( ![properties containsObject:CLUMN_UPDATE_TIME] )
    {
        [fmdbSql appendString:@", "];
        [fmdbSql appendString:CLUMN_UPDATE_TIME];
        [tailSql appendString:@", "];
        [tailSql appendString:@"?"];
        [values addObject:@([[NSDate date] timeIntervalSince1970])];
    }
    
    if ( ![properties containsObject:keyColumn] )
    {
        [fmdbSql appendString:@", "];
        [fmdbSql appendString:keyColumn];
        [tailSql appendString:@", "];
        [tailSql appendString:@"?"];
        [values addObject:[obj valueForKeyPath:keyColumn]];
    }
    
    [fmdbSql appendString:@") \n"];
    [tailSql appendString:@") \n"];
    [fmdbSql appendString:@" VALUES "];
    [fmdbSql appendFormat:@"%@ ", tailSql];
    if ( ![_db executeUpdate:fmdbSql withArgumentsInArray:values] ) {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    
    EVLog(@"update to table - \n %@ \n %@", properties ,fmdbSql);
}

- (void)updateToTableWithObject:(EVBaseObject *)obj
{
    NSString *className = NSStringFromClass([obj class]);
    NSString *tableName = [self tableNameWithClass:[obj class]];
    
    if ( ![self.tables containsObject:tableName] ) {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    
    NSMutableDictionary *class_table_info = _sqliteDictionary[className];
    NSDictionary *defaulatValueForPorperties = [[obj class] defalutValueForProperties];
    NSMutableDictionary *objDict = [obj objectDictionary];
    
    NSDictionary *classArrayPropertyMap = [[obj class] gp_objectClassesInArryProperties];
    // + (NSDictionary *)gp_objectClassesInArryProperties
    
    NSMutableString *values = [NSMutableString string];
    NSString *keyColumn = [[obj class] keyColumn];
    NSString *keyColumnType = [[obj class] keyColumnType];
#ifdef EVDEBUG
    NSAssert(keyColumn && keyColumnType, @"必须指定 keyColumn keyColumnType");
#endif
    NSMutableString *sql = [NSMutableString string];
    // INSERT OR REPLACE INTO t_manage_table
    [sql appendString:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@\n", tableName]];
    [sql appendString:@"(\n"];
    
    [class_table_info enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *property_type_in_table, BOOL *stop) {
        [sql appendString:propertyName];
        [sql appendString:@","];
        
        id value = defaulatValueForPorperties[propertyName];
        if ( value == nil )
        {
            value = objDict[propertyName];
        }
        if ( [property_type_in_table isEqualToString:COLUMN_TYPE_PRIMARY_KEY] )
        {
#ifdef EVDEBUG
            NSAssert(value && ![value isKindOfClass:[NSNull class]], @"主键不能为空值");
#endif
            [self updateTableColumn:keyColumnType propertyValue:value toValues:values];
        }
        else if ( [property_type_in_table isEqualToString:COLUMN_TYPE_JSON] && classArrayPropertyMap[propertyName] != nil && [value isKindOfClass:[NSArray class]] )
        {
            NSMutableArray *result = [NSMutableArray array];
            for (EVBaseObject *item in value) {
                if ( [item isKindOfClass:[NSDictionary class]] )
                {
                    [result addObject:item];
                }
                else
                {
                    [result addObject:[item objectDictionary]];
                }
            }
            [self updateTableColumn:property_type_in_table propertyValue:result toValues:values];
        }
        else
        {
            [self updateTableColumn:property_type_in_table propertyValue:value toValues:values];
        }

        [values appendString:@",\n"];
    }];
    [sql appendString:CLUMN_UPDATE_TIME];
    
    [sql appendString:@")\n"];
    
    [sql appendString:@"VALUES\n"];
    
    [sql appendString:@"(\n"];
    
    [values appendString:[NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]]];
    
    [sql appendString:values];
    
    [sql appendString:@")\n"];
    if ( ![_db executeUpdate:sql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    
    EVLog(@"UPDATE TABLE -- \n%@",sql);
}


- (void)updateTableColumn:(NSString *)property_type_in_table propertyValue:(id)value toValues:(NSMutableString *)values
{
    if ( [value isKindOfClass:[NSNull class]] )
    {
        value = nil;
    }
    
    if ( [property_type_in_table isEqualToString:COLUMN_TYPE_INTEGER] )
    {
        if ( value == nil )
        {
            [values appendString:[NSString stringWithFormat:@"%d", 0]];
        }
        else
        {
            [values appendString:[NSString stringWithFormat:@"%ld", [value integerValue]]];
        }
    }
    else if ( [property_type_in_table isEqualToString:COLUMN_TYPE_FLOAT] )
    {
        if ( value == nil )
        {
            [values appendString:[NSString stringWithFormat:@"%f", 0.0]];
        }
        else
        {
            [values appendString:[NSString stringWithFormat:@"%f", [value floatValue]]];
        }
    }
    else if ( [property_type_in_table isEqualToString:COLUMN_TYPE_STRING] )
    {
        if ( value == nil )
        {
            [values appendString:@"''"];
        }
        else
        {
            if ( [value isKindOfClass:[NSString class]] && [value cc_containString:@"'"] )
            {
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            }
            NSString *str = [NSString stringWithFormat:@"'%@'", value];
            [values appendString:str];
        }
    }
    else if ( [property_type_in_table isEqualToString:COLUMN_TYPE_JSON] )
    {
        if ( value == nil )
        {
            [values appendString:@"''"];
        }
        else
        {
#ifdef EVDEBUG
            NSAssert([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]], @"请检查该属性的类型");
#endif
            
            [values appendString:[NSString stringWithFormat:@"'%@'", [[value jsonString] base64Encoding]]];
        }
    }
    else
    {
        [values appendString:@"'0'"];
#ifdef EVDEBUG
        assert(0);
#endif
    }
}

- (void)checkObject:(EVBaseObject *)obj
{
    NSString *tableName = [self tableNameWithClass:[obj class]];
    [self registToMemoryWithObject:obj];
    if ( ![[self currentTable] containsObject:tableName] )
    {
        [self createTableWithObj:obj];
    }
}

- (void)createTableWithObj:(EVBaseObject *)obj
{
    NSString *className = NSStringFromClass([obj class]);
    NSDictionary *classInfo = _sqliteDictionary[className];
    NSString *tableName = [self tableNameWithClass:[obj class]];
    NSString *keyColumn = [[obj class] keyColumn];
    NSString *keyColumnType = [[obj class] keyColumnType];
    
#ifdef EVDEBUG
    NSAssert(keyColumn && keyColumnType, @"keyColumn & keyColumnType CANOT BO BE NIL ");
#endif
    
//    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
//    EVLog(@"DROP TABLE -- \n%@",sql);
//    if ( ![_db executeUpdate:sql] )
//    {
//#ifdef EVDEBUG
//        assert(0);
//#endif
//    }
    [self dropTableWithName:tableName];
    
    NSMutableString *createTableSql = [NSMutableString string];
    [createTableSql appendString:@"CREATE TABLE \n"];
    [createTableSql appendString:@"IF NOT EXISTS \n"];
    [createTableSql appendString:[NSString stringWithFormat:@"%@ (\n",tableName]];
    [classInfo enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, NSString *column_type, BOOL *stop) {
        EVLog(@"-------------%@",property_name);
        if ( [column_type isEqualToString:COLUMN_TYPE_JSON] )
        {
            column_type = COLUMN_TYPE_STRING;
            [createTableSql appendString:[NSString stringWithFormat:@"%@ %@ ,\n",property_name,column_type]];
        }
        else if ( [column_type isEqualToString:COLUMN_TYPE_PRIMARY_KEY] )
        {
            column_type = keyColumnType;
             [createTableSql appendString:[NSString stringWithFormat:@"%@ %@ NOT NULL PRIMARY KEY,\n",property_name,column_type]];
        }
        else
        {
            [createTableSql appendString:[NSString stringWithFormat:@"%@ %@ ,\n",property_name,column_type]];
        }
    }];
    
    [createTableSql appendString:[NSString stringWithFormat:@"%@ INTEGER NOT NULL DEFAULT 0\n",CLUMN_UPDATE_TIME]];
    [createTableSql appendString:@")\n"];
    
    if ( ![_db executeUpdate:createTableSql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    // inserti into manager table
    EVLog(@"CREATA TABLE - \n%@", createTableSql);
    [self insertIntoManagerTable:tableName obj:obj];
}

- (void)insertIntoManagerTable:(NSString *)tableName obj:(EVBaseObject *)instance
{
    NSString *className = NSStringFromClass([instance class]);
    id clz = [instance class];
    NSInteger version = [clz tableVersion];
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"INSERT OR REPLACE INTO t_manage_table\n"];
    [sql appendString:@"( table_name, class_name, version )\n"];
    [sql appendString:@"VALUES\n"];
    [sql appendString:[NSString stringWithFormat:@"('%@', '%@', %ld)\n",tableName, className, version]];
    if ( ![_db executeUpdate:sql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    [self.tables addObject:tableName];
    // inserti into manager table
    EVLog(@"inserti into manager table - \n%@", sql);
}

+ (instancetype)shareInstance
{
    static EVDB *db= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[self alloc] init];
    });
    return db;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        _db_queue = dispatch_queue_create("oupai.db.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)_prepare
{
    NSString *db_path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.png"];
    EVLog(@"db_path - %@",db_path);
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    
    if ( !(self.open = [db open]))
    {
        EVLog(@"Could not open db.!!!!!!!!!!!!!!!!");
        return;
    }
    _db = db;
    [db setShouldCacheStatements:YES];
    [self check];
    
}

- (void)check
{
    NSArray *tables = [self currentTable];
    
    if ( tables.count == 0 )
    {
        [self createManageTable];
    }
    else
    {
        [self dropExpireTable];
    }
}

- (void)createManageTable
{
    // table_name, version, class_name
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"CREATE TABLE\n"];
    [sql appendString:@"IF NOT EXISTS t_manage_table(\n"];
    [sql appendString:@"table_name TEXT NOT NULL DEFAULT '',\n"];
    [sql appendString:@"class_name TEXT NOT NULL DEFAULT '',\n"];
    [sql appendString:@"version INTEGER NOT NULL DEFAULT 0\n"];
    [sql appendString:@")"];
    
    EVLog(@"CREATE MANAGER TABLE - \n%@",sql);
    if ( ![_db executeUpdate:sql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
}

- (void)dropExpireTable
{
    NSString *sql = @"SELECT * FROM t_manage_table";
    NSMutableArray *dropTables = [NSMutableArray array];
    
    NSMutableArray *currTables = [NSMutableArray array];
    
    FMResultSet *rs = [_db executeQuery:sql];
    NSString *class_name = nil;
    NSInteger version = -1;
    while ( [rs next] )
    {
        class_name = [rs stringForColumn:CLASS_NAME];
        version = [rs intForColumn:VERSION];
        NSString *table_name = [rs stringForColumn:TABLE_NAME];
        if ( [self needToDropClassTable:class_name version:version] )
        {
            [dropTables addObject:table_name];
        }
        else
        {
            [currTables addObject:table_name];
        }
    }
    [rs close];
    [self cleanTables:dropTables];
    [self verifyTables:currTables];
}

- (BOOL)needToDropClassTable:(NSString *)class_name version:(NSInteger)version
{
    id clz = NSClassFromString(class_name);
    if ( [clz isSubclassOfClass:[EVBaseObject class]] )
    {
        NSInteger curr_version = [clz tableVersion];
        if ( curr_version != version )
        {
            return YES;
        }
    }
    return NO;
}

- (void)cleanTables:(NSArray *)tables
{
    if ( tables.count == 0 )
    {
        return;
    }
    
    for (NSString *table_name in tables)
    {
        [self dropTableWithName:table_name];
    }
    
}

- (void)dropTableWithName:(NSString *)table_name
{
    NSString *sql = nil;
    NSString *sql_t_manage_table = nil;
    sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", table_name];
    if ( ![_db executeUpdate:sql] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    sql_t_manage_table = [NSString stringWithFormat:@"DELETE FROM t_manage_table WHERE table_name = '%@'", table_name];
    if ( ![_db executeUpdate:sql_t_manage_table] )
    {
#ifdef EVDEBUG
        assert(0);
#endif
    }
    EVLog(@"drop table - %@",sql);
}

- (void)verifyTables:(NSArray *)tables
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - CLEAN_TIME_SPAN;
    NSString *sql = nil;
    for (NSString *table in tables)
    {
    
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ < %lf",table, CLUMN_UPDATE_TIME, time];
        if ( ![_db executeUpdate:sql] )
        {
#ifdef EVDEBUG
            assert(0);
#endif
        }
    }
}

- (BOOL)containTable:(NSString *)tableName
{
    NSArray *tables = [self currentTable];
    return [tables containsObject:tableName];
}

- (NSArray *)currentTable
{
    if ( self.tables.count != 0 ) {
        return self.tables;
    }
    NSMutableArray *tables = [NSMutableArray array];
    FMResultSet *rs = [_db executeQuery:@"SELECT tbl_name FROM sqlite_master WHERE name != 'sqlite_sequence' AND name != 't_manage_table'"];
    while ( [rs next] )
    {
        [tables addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    self.tables = tables;
    return tables;
}

- (NSString *)tableNameWithClass:(Class)clazz
{
#ifdef EVDEBUG
    assert([clazz isSubclassOfClass:[EVBaseObject class]]);
#endif
    return [NSString stringWithFormat:@"t_%@",NSStringFromClass(clazz)];
}

- (NSDictionary *)registToMemoryWithObject:(EVBaseObject *)obj
{
    NSString *className = NSStringFromClass([obj class]);
    NSMutableDictionary *class_table_info = _sqliteDictionary[className];
    NSDictionary *ignoreProperties = [[obj class] ignoreProperties];
    NSString *keyColumn = [[obj class] keyColumn];
    
#ifdef EVDEBUG
    NSAssert(keyColumn != nil, @"必须指定 keyColumn");
    NSAssert(ignoreProperties[keyColumn] == nil, @"不能忽略主键");
#endif
    
    if ( class_table_info == nil )
    {
        class_table_info = [NSMutableDictionary dictionary];
        // 1. 取出对象属性信息
        __block GPIvar *ivarModel = nil;
        [obj gp_emurateIvarsUsingBlock:^(Ivar ivar, NSString *ivarName, id value) {
            ivarModel = [GPIvar ivarWithIvar:ivar fromObject:obj];
            
            if ( ivarModel.propertyName && ignoreProperties[ivarModel.propertyName] == nil )
            {
                NSString *cloumn_type = nil;
                switch (ivarModel.ivarType)
                {
                    case GPIvarPropertyDirectKeyValueType:
                    {
                        if ( ivarModel.propertyName )
                        {
                            if ( [[GPIvar stringTypeArray] containsObject:ivarModel.typeEncode] )
                            {
                                cloumn_type = COLUMN_TYPE_STRING;
                            }
                            else if ( [[GPIvar floatTypeArray] containsObject:ivarModel.typeEncode] )
                            {
                                cloumn_type = COLUMN_TYPE_FLOAT;
                            }
                            else if ( [[GPIvar boolTypeArray] containsObject:ivarModel.typeEncode] || [[GPIvar intTypeArray] containsObject:ivarModel.typeEncode] )
                            {
                                cloumn_type = COLUMN_TYPE_INTEGER;
                            }
                        }
                    }
                        break;
                        
                    case GPIvarPropertyCollectionType:
                    case GPIvarPropertyDictionaryType:
                    case GPIvarPropertyDIYObject:
                        cloumn_type = COLUMN_TYPE_JSON;
                        break;
                        
                    default:
                        break;
                }
                if ( cloumn_type && ivarModel.propertyName && ignoreProperties[ivarModel.propertyName] == nil  )
                {
                    if ( [ivarModel.propertyName isEqualToString:keyColumn] )
                    {
                        cloumn_type = COLUMN_TYPE_PRIMARY_KEY;
                    }
                    
                    class_table_info[ivarModel.propertyName] = cloumn_type;
                }
            }
            
        }];
        _sqliteDictionary[className] = class_table_info;
    }
    return class_table_info;
}

- (EVBaseObject *)objectDictionarWithResultSet:(FMResultSet *)resultSet fromClass:(Class)clazz
{
#ifdef EVDEBUG
    assert([clazz isSubclassOfClass:[EVBaseObject class]]);
#endif
    
    if ( ![resultSet next] )
    {
        return nil;
    }
    
    return [self _objectDictionarWithResultSet:resultSet fromClass:clazz];
}

- (EVBaseObject *)_objectDictionarWithResultSet:(FMResultSet *)resultSet fromClass:(Class)clazz
{
#ifdef EVDEBUG
    assert([clazz isSubclassOfClass:[EVBaseObject class]]);
#endif
    
    EVBaseObject *obj = [[clazz alloc] init];
    NSDictionary *class_table_info = [self registToMemoryWithObject:obj];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    __block id value = nil;
    [class_table_info enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *columnType, BOOL *stop) {
        if ( [columnType isEqualToString:COLUMN_TYPE_JSON] )
        {
            NSString *jsonbase64 = [resultSet objectForColumnName:propertyName];
            if ( ![jsonbase64 isKindOfClass:[NSNull class]] && [jsonbase64 isKindOfClass:[NSString class]] )
            {
                value = [NSJSONSerialization JSONObjectWithData:[[jsonbase64 base64Decoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            }
            else
            {
                value = nil;
            }
            
        }
        else
        {
            value = [resultSet objectForColumnName:propertyName];
            if ( [value isKindOfClass:[NSNull class]] )
            {
                value = nil;
            }
        }
        
        if ( value )
        {
            result[propertyName] = value;
        }
        value = nil;
    }];
    
    return [clazz objectWithDictionary:result];
}

@end
