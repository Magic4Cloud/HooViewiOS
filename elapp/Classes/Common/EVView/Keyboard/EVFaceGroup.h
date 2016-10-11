//
//  EVFaceGroup.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVFaceGroup : NSObject

@property (nonatomic, strong) NSArray *faces;

- (instancetype)initWithFaces:(NSArray *)faces;

+ (instancetype)faceGroupWithFaces:(NSArray *)faces;

@end
