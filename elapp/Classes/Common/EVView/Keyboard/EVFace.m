//
//  EVFace.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFace.h"

@interface EVFace ()
{
    UIImage *_faceImage;
}

@end

@implementation EVFace

- (void)dealloc
{
    _faceImage = nil;
}

- (void)setFaceImageString:(NSString *)faceImageString{
    _faceImageString = [faceImageString copy];
    NSString *subStr = [faceImageString substringFromIndex:11];
    if ( subStr.length == 9  ) {
        self.faceIndex = [[subStr substringToIndex:2] integerValue];
    } else if ( subStr.length == 10 ) {
        self.faceIndex = [[subStr substringToIndex:3] integerValue];
    } else {
        self.faceIndex = [[subStr substringToIndex:1] integerValue];
    }
    _faceImage = [UIImage imageNamed:faceImageString];
}

+ (instancetype)deletFace{
    EVFace *face = [[self alloc] initWithFaceString:nil faceImageString:@"DeleteEmoticonBtn_ios7@2x"];
    face.deleteFace = YES;
    return face;
}

- (instancetype)initWithFaceString:(NSString *)faceString faceImageString:(NSString *)faceImageString{
    if ( self = [super init] ) {
        self.faceString = faceString;
        self.faceImageString = faceImageString;
    }
    return self;
}

+ (instancetype)faceWithFaceString:(NSString *)faceString faceImageString:(NSString *)faceImageString{
    return [[self alloc] initWithFaceString:faceString faceImageString:faceImageString];
}

+ (NSDictionary *)faceDictionaryWithFileName:(NSString *)fileName{
    NSString *path =[[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary *faceDict = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        faceDict[key] = [EVFace faceWithFaceString:key faceImageString:value];
    }];
    return [faceDict copy];
}

+ (NSArray *)faceArrayWithFileName:(NSString *)fileName{
    NSString *path =[[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    __block NSMutableArray *arrM= array;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [arrM addObject:[EVFace faceWithFaceString:key faceImageString:value]];
    }];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"faceIndex" ascending:YES];
    [array sortUsingDescriptors:@[descriptor]];
    return array;
}

@end
