//
//  EVEmojiTool.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EVFace;

@interface EVEmojiTool : NSObject

+ (NSArray *)emojiArray;

+ (EVFace *)faceWithFaceString:(NSString *)faceString;

/**
 *  根据字符串获得富文本，此方法只适用与该项目的富文本表情
 *
 *  @param text       输入字符串
 *  @param lineHeight 希望富文本表情的行高
 *
 *  @return 富文本字符
 */
+ (NSMutableAttributedString *)attributStringByString:(NSString *)text lineHeight:(CGFloat)lineHeight;

/**
 *  根据富文本,获得源字符串，字符串用于上传服务器
 *
 *  @param arrtibuteString 富文本字符
 *  @param countP          如果要想获得改文本字符的个数，请传入整型指针
 *
 *  @return 源字符串
 */
+ (NSString *)rawStringFromAttributString:(NSAttributedString *)arrtibuteString characterCount:(NSInteger *)countP;


@end
