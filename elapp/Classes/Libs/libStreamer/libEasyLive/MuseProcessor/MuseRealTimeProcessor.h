//
//  MsueRealTimeProcessor.h
//  Musemage
//
//  Created by YangBin on 10/4/14.
//  Copyright (c) 2014 Paraken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <OpenGLES/EAGLDrawable.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface MuseRealTimeProcessor : NSObject

@property (nonatomic, readonly)     dispatch_queue_t        queue;
@property (nonatomic)               NSInteger               styleFilter;
@property (nonatomic)               NSInteger               lensFilter;

+ (NSString *)RealTimeProcessorVersion;

- (id)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup;

- (void)effectPixelBuffer:(CMSampleBufferRef)inputSampleBuffer toPixelBuffer:(CVPixelBufferRef)outputPixelBuffer mirror:(BOOL)mirror orientation:(AVCaptureVideoOrientation)orientation recordSec:(double)recordSec;

- (void)setBeauty:(int)type;

- (void)freeAllTextures;

@end
