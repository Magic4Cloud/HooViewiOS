//
//  EVCircleRecordedModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCircleRecordedModel.h"

@implementation EVCircleRecordedModel

+ (NSArray *)videosArrayWithSubjectData:(id)videoData
{
    NSMutableArray *vidoesArray = [NSMutableArray array];
    if ( [videoData isKindOfClass:[NSDictionary class]] )
    {
        NSArray *objects = [videoData objectForKey:@"videos"];
        for (NSDictionary *objDic in objects) {   
            EVCircleRecordedModel *video = [EVCircleRecordedModel objectWithDictionary:objDic];
            [vidoesArray addObject:video];
        }
    }
    return vidoesArray;
}

+ (NSArray *)videosAarryWithMessageData:(id)messageData
{
    NSMutableArray *vidoesArray = [NSMutableArray array];
    if ( [messageData isKindOfClass:[NSDictionary class]] )
    {
        NSArray *objects = [messageData objectForKey:@"videos"];
        for (NSDictionary *objDic in objects) {
            EVCircleRecordedModel *video = [EVCircleRecordedModel objectWithDictionary:objDic];
            [vidoesArray addObject:video];
        }
    }
    return vidoesArray;
}

+ (NSArray *)cityVidesArrayWithMessageData:(id)messageData
{
    NSMutableArray *vidoesArray = [NSMutableArray array];
    if ( [messageData isKindOfClass:[NSDictionary class]] )
    {
        NSArray *objects = [messageData objectForKey:@"videos"];
        for (NSDictionary *objDic in objects) {
            EVCircleRecordedModel *video = [EVCircleRecordedModel objectWithDictionary:objDic];
            video.location = [NSString stringWithFormat:@"%.1fkm",[video.distance floatValue]/1000];
            [vidoesArray addObject:video];
        }
    }
    return vidoesArray;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if ([object isKindOfClass:[self class]] && [((EVCircleRecordedModel *)object).vid isEqualToString:self.vid])
    {
        return YES;
    }
    return NO;
}

@end
