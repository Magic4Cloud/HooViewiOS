//
//  EVChatGroupFileManager.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"


@interface EVChatGroupFileManager : CCBaseObject

+ (instancetype)shareInstance;


- (void)writeFriendsToFile:(NSArray *)friends;

- (void)friendsFromLocalForIMUsers:(NSArray *)imusers completion:(void(^)(NSArray *friends))completion;

@end
