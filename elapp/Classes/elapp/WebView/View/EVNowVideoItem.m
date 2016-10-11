//
//  EVNowVideoItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNowVideoItem.h"
#import "EVDiscoverNowVideoCell.h"
#import "NSDictionary+JSON.h"

@implementation EVNowVideoListItem

+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    EVNowVideoListItem *item = [super objectWithDictionary:dict];
    return item;
}

- (NSMutableArray *)videos
{
    if ( _videos == nil )
    {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (BOOL)mergeWithNoSquenceVides:(NSArray *)videos
{
    if ( videos.count == 0 )
    {
        return NO;
    }
    
    if ( self.videos.count == 0 )
    {
        [self.videos addObjectsFromArray:videos];
        return NO;
    }
    
    for ( NSInteger i = 0 ; i <= (NSInteger)videos.count - 1 ; i++ )
    {
        EVNowVideoItem *item = videos[i];
        if ( [self.videos containsObject:item] )
        {
            [item updateWithItem:item];
        }
        else
        {
            [self.videos addObject:item];
        }
    }
    return YES;
}

- (void)mergeWithVides:(NSArray *)videos
{

    
    if ( [self mergeWithNoSquenceVides:videos] )
    {
        [self addjustWithStartTime];
    }
}

- (void)addjustWithStartTime
{
     // 冒泡排序 按时间倒序排
    for (NSInteger i = 0; i < self.videos.count; i++)
    {
        EVNowVideoItem *item = self.videos[i];
        
        for ( NSInteger j = i + 1 ; j < self.videos.count ; j++ )
        {
            EVNowVideoItem *temp = self.videos[j];
            if ( temp.live_start_time_span < item.live_start_time_span )
            {
                self.videos[i] = temp;
                self.videos[j] = item;
                item = temp;
            }
        }
    }
    
    // 把直播中的item 放到最前面
    NSMutableArray *videos = [NSMutableArray arrayWithCapacity:self.videos.count];
    
    for ( EVNowVideoItem *item  in self.videos )
    {
        if ( item.living )
        {
            [videos insertObject:item atIndex:0];
        }
        else
        {
            [videos addObject:item];
        }
    }
    
    self.videos = videos;
    
}

// 更新视频信息，返回更新后的信息
- (NSArray *)updateViedoItemDictionaries:(NSArray *)videoDicts
{
    if ( videoDicts.count == 0 )
    {
        return nil;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:videoDicts.count];
    for ( NSDictionary *info  in videoDicts)
    {
        for (EVNowVideoItem *item in self.videos)
        {
            [item updateWithInfo:info];
        }
    }
    
    return results;
}

@end

@implementation EVNowVideoItem

+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    EVNowVideoItem *item = [super objectWithDictionary:dict];
    // 快速插入
//    [item updateToLocalCacheComplete:nil];
    return item;
}

- (void)setVid:(NSString *)vid
{
    _vid = vid;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)setThumb:(NSString *)thumb{
    _thumb = thumb;
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = nickname;
}

- (void)setLogourl:(NSString *)logourl
{
    _logourl = logourl;
}

- (void)setLiving:(BOOL)living
{
    _living = living;
}

-(void)setVip:(NSInteger)vip
{
    _vip = vip;
}

- (void)setLive_stop_time_span:(NSUInteger)live_stop_time_span
{
    _live_stop_time_span = live_stop_time_span;
}

- (NSString *)remarks
{
    return self.nickname;
}

- (BOOL)isEqual:(id)object
{
    if ( self == object )
    {
        return YES;
    }
    
    if ( [object isKindOfClass:[EVNowVideoItem class]] )
    {
        EVNowVideoItem *temp = object;
        return [temp.vid isEqualToString:self.vid];
    }
    
    return NO;
}

- (void)updateWithItem:(EVNowVideoItem *)item
{
    if ( ![item.vid isEqualToString:self.vid] )
    {
        return;
    }
    
    self.comment_count = item.comment_count;
    self.duration = item.duration;
    self.like_count = item.like_count;
    self.live_start_time = item.live_start_time;
    self.live_start_time_span = item.live_start_time_span;
    self.live_stop_time = item.live_stop_time;
    self.live_stop_time_span = item.live_stop_time_span;
    self.living = item.living;
    self.location = item.location;
    self.logourl = item.logourl;
    self.name = item.name;
    self.nickname = item.nickname;

    self.thumb = item.thumb;
    self.title = item.title;
    self.vip = item.vip;
    self.watch_count = item.watch_count;
    self.watching_count = item.watching_count;
}

- (BOOL)updateWithInfo:(NSDictionary *)info
{
    NSString *vid = info[kVid];
    if ( ![vid isEqualToString:self.vid] )
    {
        return NO;
    }
    
    self.comment_count = [[info cc_objectWithKey:kComment_count] integerValue];
    self.duration = [[info cc_objectWithKey:kDuration] stringValue];
    self.like_count = [[info cc_objectWithKey:kLike_count] integerValue];
    self.live_start_time = [info cc_objectWithKey:kLive_start_time];
    self.live_start_time_span = [[info cc_objectWithKey:kLive_start_time_span] integerValue];
    self.live_stop_time = [info cc_objectWithKey:kLive_stop_time];
    self.live_stop_time_span = [[info cc_objectWithKey:kLive_stop_time_span] integerValue];
    self.living = [[info cc_objectWithKey:kLiving] boolValue];
    self.location = [info cc_objectWithKey:kLocation];
    self.logourl = [info cc_objectWithKey:kLogourl];
    self.name = [info cc_objectWithKey:kNameKey];
    self.nickname = [info cc_objectWithKey:kNickName];
    NSString *thumb = [info cc_objectWithKey:kThumb];
    self.updateThumb = ![thumb isEqualToString:self.thumb];
    self.thumb = thumb;
    self.title = [info cc_objectWithKey:kTitle];
    self.watch_count = [[info cc_objectWithKey:kWatch_count] integerValue];
    self.watching_count = [[info cc_objectWithKey:kWatching_count] integerValue];
    
    [self.cell updateDataWithAnimation:self];
    
    return YES;
}

@end
