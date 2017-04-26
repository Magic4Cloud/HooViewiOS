//
//  EVUserModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVUserModel.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "EVLoginInfo.h"
#import "EVUserTagsModel.h"
@implementation EVUserModel


#pragma mark - 重写字典转模型的方法

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"auth" : [EVRelationWith3rdAccoutModel class],
             @"tags" : [EVUserTagsModel class]};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"userid":@"name"};
}



#pragma mark - 重写数据库类要用的方法
+ (NSString *)keyColumn
{
    return @"name";
}

+ (NSString *)keyColumnType
{
    return COLUMN_TYPE_STRING;
}

+ (NSInteger)tableVersion
{
    return 12;
}

+ (NSDictionary *)ignoreProperties
{
    return @{@"is_current_user" : @"is_current_user"};
}

+ (void)updateFollowStateWithName:(NSString *)name followed:(BOOL)follow completet:(void(^)(EVUserModel *model))complete
{
    [self getUserInfoModelWithName:name complete:^(EVUserModel *model) {
        if ( model )
        {
            EVQueryObject *obj = [[EVQueryObject alloc] init];
            obj.clazz = [self class];
            model.followed = follow;
            obj.to_update_property_name = @[@"followed"];
            obj.properties_condition_values = @[model.name];
            obj.properties_condition_symbol = @[CONDITION_SYMBOL_EQUAL];
            obj.properties = @[@"name"];
            
            [model updateToLocalCacheWithCondition:obj complete:^{
                if ( complete )
                {
                    complete(model);
                }
            }];
        }
        else if ( complete )
        {
            complete(model);
        }
    }];
}

- (void)updateToLocalCacheComplete:(void (^)())complete
{
//    [super updateToLocalCacheComplete:^{
//        if ( complete )
//        {
//            complete();
//        }
//        [[self class] userModelUpdateToLocalNotification:self];
//    }];
}

#pragma mark - private methods
+ (void)getUserInfoModelWithName:(NSString *)name complete:(void(^)(EVUserModel *model))complete
{
    EVQueryObject *query = [[EVQueryObject alloc] init];
    query.clazz = [self class];
    query.properties = @[@"name"];
    query.properties_condition_values = @[name];
    query.properties_condition_symbol = @[CONDITION_SYMBOL_EQUAL];

    [[self class] queryWithQueryObj:query complete:^(NSArray *results) {
        if ( complete)
        {
            complete( [results lastObject] );
        }
    }];
}

+ (void)getUserInfoModelWithIMUser:(NSString *)imuser complete:(void (^)(EVUserModel *))complete
{
    if (imuser == nil) {
        return;
    }
    EVQueryObject *query = [[EVQueryObject alloc] init];
    query.clazz = [self class];
    query.properties = @[@"imuser"];
    query.properties_condition_values = @[imuser];
    query.properties_condition_symbol = @[CONDITION_SYMBOL_EQUAL];
    [[self class] queryWithQueryObj:query complete:^(NSArray *results) {
        if ( complete)
        {
            complete( [results lastObject] );
        }
    }];
}

- (NSString *)signature
{
    if ( _signature == nil || _signature.length == 0 )
    {
        return kDefaultSignature_other;
    }
    return _signature;
}


+ (void)userModelUpdateToLocalNotification:(EVUserModel *)userModel
{
    [EVNotificationCenter postNotificationName:CCUserModelUpdateToLocalNotification object:nil userInfo:@{CCUpdateUserModel : userModel}];
}

+ (instancetype)getUserInfoModelFromLoginInfo:(EVLoginInfo *)loginInfo
{
    EVUserModel *user = [[EVUserModel alloc] init];
    user.name = loginInfo.name;
    user.auth = loginInfo.auth;
    user.nickname = loginInfo.nickname;
    user.authtype = loginInfo.authtype;
    
    return user;
}

@end
