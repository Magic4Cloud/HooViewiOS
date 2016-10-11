//
//  EVControllerContacter.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVControllerContacter.h"

@implementation EVControllerItem

- (void)receiveEvent:(NSString *)event withParams:(NSDictionary *)params
{
    if ( [self.delegate respondsToSelector:@selector(receiveEvents:withParams:)] )
    {
        [self.delegate receiveEvents:event withParams:params];
    }
}

- (NSMutableArray *)events
{
    if ( _events == nil )
    {
        _events = [NSMutableArray array];
    }
    return _events;
}

@end

@interface EVControllerContacter ()

@property (nonatomic,strong) NSMutableDictionary *map;

@property (nonatomic, assign) BOOL needToClean;

@end

@implementation EVControllerContacter

#pragma mark - 2.0.2
- (void)addListener:(EVControllerItem *)item
{
    for (NSString *event in item.events) {
        NSMutableArray *list = [self listenerListFromMapWithevents:event];
        if ( ![list containsObject:item] ) {
            [list addObject:item];
        }
    }
}

- (void)boardCastEvent:(NSString *)event withParams:(NSDictionary *)params
{
    NSMutableArray *list = [self listenerListFromMapWithevents:event];
    for (EVControllerItem *item in list) {
        [item receiveEvent:event withParams:params];
    }
}

- (void)popEvent:(NSString *)event fromListenerItem:(EVControllerItem *)listener
{
    [listener.events removeObject:event];
    NSMutableArray *list = [self listenerListFromMapWithevents:event];
    if ( [list containsObject:listener] ) {
        [list removeObject:listener];
    }
}

- (NSMutableDictionary *)map{
    if ( _map == nil ) {
        _map = [NSMutableDictionary dictionary];
    }
    return _map;
}

- (NSMutableArray *)listenerListFromMapWithevents:(NSString *)event{
    @synchronized([self class]) {
        NSMutableArray *list = [self.map objectForKey:event];
        if ( list == nil ) {
            list = [NSMutableArray array];
            [self.map setObject:list forKey:event];
        }
        return list;
    }
}

@end
