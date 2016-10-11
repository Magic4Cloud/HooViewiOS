//
//  EVFaceAttachment.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVFace;

@interface EVFaceAttachment : NSTextAttachment

@property (nonatomic, copy) NSString *faceString;

+ (NSAttributedString *)attributedStringWith:(EVFace *)face lineHeight:(CGFloat)lineHeight;

@end
