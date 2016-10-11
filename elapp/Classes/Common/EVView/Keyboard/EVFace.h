//
//  EVFace.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVFace : NSObject

@property (nonatomic, assign) NSInteger faceIndex;

@property (nonatomic, copy) NSString *faceString;

@property (nonatomic,assign) NSRange rangeInString;

@property (nonatomic, copy) NSString *faceImageString;

@property (nonatomic, strong,readonly) UIImage *faceImage;

@property (nonatomic, assign) BOOL deleteFace;

- (instancetype)initWithFaceString:(NSString *)faceString faceImageString:(NSString *)faceImageString;

+ (instancetype)faceWithFaceString:(NSString *)faceString faceImageString:(NSString *)faceImageString;

+ (instancetype)deletFace;

+ (NSDictionary *)faceDictionaryWithFileName:(NSString *)fileName;

+ (NSArray *)faceArrayWithFileName:(NSString *)fileName;

@end
