//
//  EVPushBar.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVPushBar : UIButton

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)pushBarWithTitle:(NSString *)title;

@property (nonatomic, assign) BOOL isPushBarRemove;

@property (nonatomic, strong) NSDictionary *userInfo;

@end
