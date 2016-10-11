//
//  EVFaceTextView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVFace;

@interface EVFaceTextView : UITextView

@property (nonatomic, copy) NSString *contentString;

@property (nonatomic, assign,readonly) NSInteger emojiStringLength;

@property (nonatomic, strong) NSAttributedString *contentAttributedString;

- (void)inputFace:(EVFace *)face;

- (NSString *)rawString;

@end
