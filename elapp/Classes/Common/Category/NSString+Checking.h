//
//  NSString+Checking.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Checking)


/**
 *  @author 杨尚彬
 *
 *  检查是否是手机号
 *
 *  @return 
 */
//- (BOOL)isPhoneNumber;

- (BOOL)CC_isPhoneNumberNew;

/**
 *  @author 杨尚彬
 *
 *  检查是否是邮箱
 *
 *  @return
 */
- (BOOL)isEmail;

@end
