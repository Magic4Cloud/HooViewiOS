//
//  EVWatchVideoInfo.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVWatchVideoInfo.h"
#import "EVLoginInfo.h"
#import "EVRecoderInfo.h"
#import "EVUserTagsModel.h"
@implementation EVWatchVideoInfo
+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id":@"liveID"};
}

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"tags" : [EVUserTagsModel class]};
}
+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    EVWatchVideoInfo *instance = [super objectWithDictionary:dict];
    NSString *currUserName = [EVLoginInfo localObject].name;
    if ( [instance.name isEqualToString:currUserName] )
    {
        instance.followed = YES;
    }
    return instance;
}

- (void)setPlay_url:(NSString *)play_url
{
    _play_url = [play_url copy];
    NSURL *url = [NSURL URLWithString:_play_url];
    self.host = [url host];
}

- (void)setThumb:(NSString *)thumb
{
    _thumb = [thumb copy];
}


- (void)setLive_start_time:(NSString *)live_start_time
{
    if ( ![live_start_time isKindOfClass:[NSString class]] )
    {
        live_start_time = [NSString stringWithFormat:@"%@", live_start_time];
    }
    NSArray *arr = [live_start_time componentsSeparatedByString:@" "];
    if ( arr.count )
    {
        live_start_time = arr[0];
    }
    _live_start_time = live_start_time;
}

- (EVLiveUserInfo *)liveUserInfo
{
    if (!_liveUserInfo)
    {
        _liveUserInfo = [[EVLiveUserInfo alloc] init];
    }
    return _liveUserInfo;
}

@end
