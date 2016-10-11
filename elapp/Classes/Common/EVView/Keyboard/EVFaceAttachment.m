//
//  EVFaceAttachment.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVFaceAttachment.h"
#import "EVFace.h"

@implementation EVFaceAttachment

+ (NSAttributedString *)attributedStringWith:(EVFace *)face lineHeight:(CGFloat)lineHeight{
    EVFaceAttachment *attachement = [[EVFaceAttachment alloc] init];
    attachement.faceString = face.faceString;
    attachement.bounds = CGRectMake(0, -4, lineHeight, lineHeight);
    attachement.image = face.faceImage;
    return [NSAttributedString attributedStringWithAttachment:attachement];
}

@end
