//
//  EVFriendCircleRanklistModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFriendCircleRanklistModel.h"

@implementation CCFriendCircleRanklistSendModel

@end

@implementation CCFriendCircleRanklistReceiveModel

@end

@implementation EVFriendCircleRanklistModel

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"send_rank_list" : [CCFriendCircleRanklistSendModel class], @"receive_rank_list": [CCFriendCircleRanklistReceiveModel class]};
}

@end
