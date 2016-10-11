//
//  EVFaceGroup.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFaceGroup.h"

@implementation EVFaceGroup

- (instancetype)initWithFaces:(NSArray *)faces{
    if ( self = [super init] ) {
        self.faces = faces;
    }
    return self;
}

+ (instancetype)faceGroupWithFaces:(NSArray *)faces{
    return [[self alloc] initWithFaces:faces];
}

@end
