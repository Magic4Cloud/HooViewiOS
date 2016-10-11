//
//  EVRecoderInfo.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVRecoderInfo.h"
#import "EVComment.h"
#import "EVAudience.h"
#import "EVVideoTopicItem.h"
#import "EVStartResourceTool.h"

@implementation EVLiveViedeoStatus

@end

@implementation EVLiveVideoInfo

- (void)setLike_count:(NSUInteger)like_count
{
    if ( _like_count < like_count )
    {
        _like_count = like_count;
    }
}

@end

@implementation EVLiveUserInfo

- (EVLiveVideoInfo *)video_info
{
    if (!_video_info)
    {
        _video_info = [[EVLiveVideoInfo alloc] init];
    }
    return _video_info;
}

+ (instancetype)liveUserInfoWithJSONString:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return [self objectWithDictionary:info];
}

- (void)setUsername:(NSString *)username
{
    _username = [username copy];
}

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"watching_list": [EVAudience class], @"comments": [EVComment class]};
}

@end

@implementation EVRecoderInfo

- (EVLiveUserInfo *)liveUserInfo
{
    if (!_liveUserInfo)
    {
        _liveUserInfo = [[EVLiveUserInfo alloc] init];
    }
    return _liveUserInfo;
}

- (void)setLiveid:(NSString *)liveid
{
    _liveid = [NSString stringWithFormat:@"%@",liveid];
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    self.thumb = YES;
}


- (NSMutableDictionary *)liveStartParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( self.vid )
    {
        params[kVid] = self.vid;
    }
    
    if ( self.title )
    {
        params[kTitle] = self.title;
    }
    params[kThumb] = @(self.thumb);
    
    params[kAccompany] = @(self.accompany);
    
    params[kGPS] = @(self.shareLocation);
    
    if (self.password) {
        params[kPassword] = self.password;
    }
    
    if (self.payPrice) {
        params[kPrice]  = self.payPrice;
    }
    
    if (self.permission) {
        params[kPermissionKey] = @(self.permission);
    }
    
    return params;
}

- (NSString *)title
{

    return _title;
}


- (instancetype)init
{
    if ( self = [super init] )
    {
        self.shareLocation = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    if ( scale >= 1 )
    {
        _scale = scale;
    }
    else
    {
        _scale = 1;
    }
}

- (void)setVid:(NSString *)vid
{
    _vid = [vid copy];
}

- (EVTopicItem *)topic
{
    if ( _accompany && _topic == nil )
    {
        EVTopicItem *temp = [[EVTopicItem alloc] init];
        NSArray *topics = [[EVStartResourceTool shareInstance] topicItems];
        for (EVVideoTopicItem *topic in topics)
        {
            if ([topic.title isEqualToString:kE_GlobalZH(@"pei_ban")])
            {
                temp.Id = topic.topic_id;
                temp.title = topic.title;
                temp.descriptions = topic.topic_description;
                break;
            }
        }
        _topic = temp;
    }
    return _topic;
}

@end
