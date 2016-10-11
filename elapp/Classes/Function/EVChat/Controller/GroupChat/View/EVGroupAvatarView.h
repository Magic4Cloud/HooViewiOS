//
//  EVGroupAvatarView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVGroupAvatarView : UIView

- (instancetype)initWithFrame:(CGRect)frame avatarArray:(NSArray *)avatarArray;
- (UIImage *)getAvatarImage;

+ (UIImage *)imageWithLogourlArray:(NSArray *)array;

@end
