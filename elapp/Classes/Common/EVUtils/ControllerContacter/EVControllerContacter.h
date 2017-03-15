//
//  EVControllerContacter.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EVControllerContacter;

@protocol EVControllerContacterProtocol <NSObject>

@optional
- (void)receiveEvents:(NSString *)event withParams:(NSDictionary *)params;

@end

@interface EVControllerItem : NSObject

@property (nonatomic,weak) id<EVControllerContacterProtocol> delegate;

@property (nonatomic,strong) NSMutableArray *events;

- (void)receiveEvent:(NSString *)event withParams:(NSDictionary *)params;

@end

@interface EVControllerContacter : NSObject

- (void)addListener:(EVControllerItem *)item;

- (void)popEvent:(NSString *)event fromListenerItem:(EVControllerItem *)item;

- (void)boardCastEvent:(NSString *)event withParams:(NSDictionary *)params;

@end
