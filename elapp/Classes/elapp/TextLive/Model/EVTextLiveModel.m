//
//  EVTextLiveModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVTextLiveModel.h"
#define kTextInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EVTextLiveModel.arc"]
@implementation EVTextLiveModel
+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id":@"streamid"};
}


- (id)initWithCoder:(NSCoder *)decoder
{
    EVTextLiveModel *loginInfo = [[[self class] alloc] init];
    loginInfo.streamid = [decoder decodeObjectForKey:@"streamid"];
    loginInfo.viewcount = [decoder decodeIntegerForKey:@"viewcount"];
    loginInfo.state = [decoder decodeObjectForKey:@"state"];
    loginInfo.name = [decoder decodeObjectForKey:@"name"];

    return loginInfo;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.streamid forKey:@"streamid"];
    [encoder encodeInteger:self.viewcount forKey:@"viewcount"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.name forKey:@"name"];
   
    
}

- (void)synchronized
{
    EVLog(@"%@",kTextInfoPath);
    if ([self.name isEqualToString:@""] || self.name == nil) {
        return;
    }
    if ( [NSKeyedArchiver archiveRootObject:self toFile:kTextInfoPath] )
    {
        EVLog(@"archieve success");
    }
    else
    {
        EVLog(@"archieve fail");
    }
}

+ (EVTextLiveModel *)textLiveObject
{
    EVTextLiveModel *info = [NSKeyedUnarchiver unarchiveObjectWithFile:kTextInfoPath];
    return info;
}

+ (void)cleanTextLiveInfo
{
    [[NSFileManager defaultManager] removeItemAtPath:kTextInfoPath error:NULL];
}
@end
