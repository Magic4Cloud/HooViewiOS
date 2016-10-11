//
//  NSArray+Group.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Group)

/**
 *  @author 杨尚彬
 *
 *  获取分好组的二维数组
 *
 *  @param string 数组中元素的某一字符串属性
 *
 *  @return 按obj的某一个字符串属性的首字母分组后的二维数组
 */
-(NSArray *)subArraysWithString:(NSString *(^)(id obj))string;

/**
 *  @author 杨尚彬
 *
 *  获取所欲分组的名字数组(ABCD...)
 *
 *  @discussion 此方法在调用subArraysWithString:之后才会有值
 *
 */
- (NSArray *)groupNames;


@end
