//
//  NSString+Checking.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "NSString+Checking.h"

@implementation NSString (Checking)


// 检查是否位合法的手机号
- (BOOL)CC_isPhoneNumberNew
{
    NSString *pattern = @"([0-9]{7,15})";
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:NULL];
    NSTextCheckingResult *result = [regx firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, self.length)];
    return result != nil && self.length <= 15;
}

// 检查是否位合法的email地址
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
