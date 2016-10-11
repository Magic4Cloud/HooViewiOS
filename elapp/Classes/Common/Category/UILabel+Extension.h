//
//  UILabel+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CCCellTypeVideo,    /**< 视频 */
    CCCellTypeAudeo,    /**< 音频 */
} CCCellType;   /**< cell类型 */

@interface UILabel (Extension)

/**
 *  滚动数字动画，注意改label.text 只能含有整数字符
 *
 *  @param count 总数 ，
 */
- (void)animationWithCount:(NSInteger)count;

/**
 *  根据字符串给label填充表情，该方法已经处理emoji字符
 *
 *  @param text 输入字符
 */
- (void)cc_setEmotionWithText:(NSString *)text;

/**
 *  如果该 label 适用了 富文本，适用此方法从富文本中获得纯字符串，该方法已经处理emoji字符
 *
 *  @return 纯字符串
 */
- (NSString *)cc_rawStringFromAttributeString;

///**
// *  适配 emoji 字符
// *
// *  @param text 输入文本
// */
//- (void)cc_setUniCodeText:(NSString *)text;

//
/**
 *  采用富文本的形式（含有图片）对label的内容进行展示(观看数、点赞数、评论数)
 *
 *  @param watchCount   观看数
 *  @param like         点赞数
 *  @param commentCount 评论数
 */
- (void)setAttributeTextWithWatch:(NSUInteger)watchCount
                             like:(NSUInteger)likeCount
                          comment:(NSUInteger)commentCount
                         fontSize:(CGFloat)fontSize
    titleToTitleWhitespaceNumbers:(NSInteger)t_t_space_nums
                             type:(CCCellType)type;

/**
 *  返回一个带阴影的label
 *
 *  @param bgColor      背景色
 *  @param textColor    文色
 *  @param font         字体
 *  @param shadowColor  阴影颜色
 *  @param shadowOffset 阴影偏移量
 *
 *  @return label
 */
+ (UILabel *)labelWithBackgroundColor:(UIColor *)bgColor
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                          shadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset;


/**
 *  返回一个带黑色阴影的label
 *
 *  @param textColor 字体颜色
 *  @param font      字体
 *
 *  @return label
 */
+ (UILabel *)labelWithDefaultShadowTextColor:(UIColor *)textColor
                                        font:(UIFont *)font;

/**
 *  返回一个设定字体的label
 *
 *  @param bgColor       背景色
 *  @param textColor     字色
 *  @param font          字体
 *  @param textAlignment 文字对齐方式
 *
 *  @return label
 */
+ (UILabel *)labelWithBackgroundColor:(UIColor *)bgColor
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                        textAlignment:(NSTextAlignment)textAlignment;

/**
 *  返回一个默认的label
 *
 *  @param textColor 字体颜色
 *  @param font      字体
 *
 *  @return label
 */
+ (UILabel *)labelWithDefaultTextColor:(UIColor *)textColor
                                  font:(UIFont *)font;

@end
