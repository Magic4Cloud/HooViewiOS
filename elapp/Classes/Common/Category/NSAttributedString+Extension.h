//
//  NSAttributedString+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSAttributedString (Extension)

/**
 *  把富文本转化为纯字符串，已经做了 emoji 字符的解析
 *
 *  @param countP 字符个数指针,如果不需要该参数请传 NULL
 *
 *  @return 纯字符串
 */
- (NSString *)cc_rawStringWithCharacterCount:(NSInteger *)countP;

@end
