//
//  NSString+Extension.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 *  字符个数
 *
 *  @return 字符个数
 */
//- (NSUInteger)wordCount;

/**
 *  对字符串进行md5加密
 */
- (NSString *)md5String;

/**
 *  字符串中是否包含某个子字符串
 *
 *  @param subString 子字符串
 *
 *  @return YES包含，NO不包含
 */
- (BOOL)cc_containString:(NSString *)subString;

/**
 *  过滤解析服务器带有 emoji 占位字符的字符串
 *  如 abc[smile]cd - > abc😄cd
 *  @return emoji字符
 */
//- (NSString *)cc_rawStringToEmojiString;
//
///**
// *  把带有 emoji 表情的字符串 转换为纯字符串
// *
// *  如 abc😄cd -> bc[smile]cd
// *  @return 纯字符串
// */
//- (NSString *)cc_emojiStringToRawString;

/**
 *  根据行高获得富文本次方法已经解析过 emoji 字符
 *
 *  @param lineHeight 行高（传 font.lineHeight）
 *
 *  @return 富文本
 */
- (NSMutableAttributedString *)cc_attributStringWithLineHeight:(CGFloat)lineHeight;

/** 根据要求获取某些字符被替换成图片的富文本字符串 */
- (NSAttributedString *)attributeStringWithReplaceRange:(NSRange)range replaceImage:(NSString *)imageName textColor:(UIColor *)color font:(UIFont *)font;

/** 数字以万、亿为单位生成字符串，四舍五入保留一位小数 */
+ (NSString *)shortNumber:(NSUInteger)count;

/** 根据时间间隔（单位：s），计算视频距当前的时间：1分钟前、1小时前、1天前、1月前、1年前、年月日 */
+ (NSString *)timeStampWithStopSpan:(NSUInteger)stopSpan stopTime:(NSString *)stopTime;

/**用来计算时间*/

///**
// *  根据秒数获得具体时间
// *
// *  @param second 秒数
// *
// *  @return xxx日xxx时xxx分
// */
//- (NSString *)concreteTimeWithSecond;

/**
 *  返回只有日期的时间字符串
 *
 *  @param stopTime 停止时间
 */
+ (NSString *)dateTimeStampWithStoptime:(NSString *)stopTime;

/**
 *  转化日期格式
 *
 *  @param dateForm 要转换到的日期格式，eg：@"2015年6月30日 10点10分"
 *
 *  @return 按格式转换后的日期字符串
 */
- (NSString *)translateDateToForm:(NSString *)dateFormat;
/**
 *  转换字符
 *
 *  @return <#return value description#>
 */
- (NSUInteger)numEnglishWord;

/**
 *  字符串中包含的字符数
 *  limit为0时表示无限制
 *  @return 一个汉字是1个字符，一个英文或者数字是0.5字符
 */
- (NSUInteger)numOfWordWithLimit:(NSInteger)limit;

//判断中英文截取字符串的数
- (NSUInteger)stringToIndexLength:(NSInteger)length;

/**
 *  判空
 *
 *  @return 字符串是否为空
 */
- (BOOL)isNotEmpty;

/**
 *  用于计算播放器播放时间
 *
 *  @param seconds 时间数 秒
 *^
 *  @return 格式化后的字符
 */
+ (NSString *)stringFormattedTimeFromSeconds:(double *)seconds;

+ (NSString *)stringFormattedTimeWithNoHHFromSeconds:(double *)seconds;

/**
 *
 *  把NSNumber类型的时长转成字符串
 *
 *  @param duration 时长
 *
 *  @return 时间类型的时长
 */
+ (NSString *)stringFormattedTimeFromDuration:(NSNumber *)duration;

/**
 *  base64解码
 *
 *  终端测试命令：
 *  @code
 *  echo -n QQ== | base64 -D
 *  @endcode
 *
 *  @return base64解码之后的字符串
 */
- (NSString *)base64Decoding;


- (NSString *)base64DecodingSuitEncoding;

/**
 *  base64编码
 *  终端测试命令
 *  @code
 *  echo -n A | base64
 *
 *  @endcode
 *
 *  @return base64编码之后的字符串
 */
- (NSString *)base64Encoding;

/**
 *  对时长进行格式转换
 *
 *  @param duration 转换前秒数格式的时长
 *
 *  @return 转换后，HH:mm:ss格式时长的字符串
 */
+ (NSString *)clockTimeDurationWithSpan:(NSInteger)duration;

/**
 *  返回一个字符串 如 : 1.7 w 看过 。8000观看中 . 1.7 w 个赞
 *
 *  @param watchingCount
 *  @param watchCount
 *  @param likeCount
 *
 *  @return 
 */
+ (NSString *)stringWithWatchingCount:(NSInteger)watchingCount;

/**
 *  转化距离的展示方式，大于1000m，以km为单位，保留一位有效小数
 *
 *  @param distance 以m为单位的距离
 *
 *  @return 转化后距离的字符串
 */
+ (NSString *)convertDistanceNumber:(NSUInteger)distance;

/**
 *  判断是否是空字符串
 *
 *  @param string 要鉴别的字符串
 *
 *  @return 是否为空字符串：YES,空; NO,非空
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *
 *  删除所有的空格
 *
 *  @return 去除空格后
 */
- (NSString *)deleteSpace;
/**
 *  根据日期选取星座
 *
 *  @return <#return value description#>
 */
+ (NSString *)judConstellationDateStr:(NSString *)dateStr;

/**
 *
 *  根据日期获取年龄
 *
 *  @param dateStr
 *
 *  @return 年龄;
 */
+ (NSString *)ageFromDateStr:(NSString *)dateStr;

/**
 *
 *  根据字符串数组获取中间有口号分割的字符串
 *
 *  @param strArray 字符串数组  eg:@[@"str1",@"str2"];
 *
 *  @return 新的字符串 eg:@"str1,str2";
 */
+ (instancetype)stringWithArray:(NSArray<NSString *> *) strArray;

/**
 *  根据机型判断美颜是否可用
 *
 *  @return YES:是, No: 否
 */
+ (BOOL)isBeautyFaceAvailable;
/**
 *  判断输入的内容是否都是数字
 *
 *  @param text <#text description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isPureNumandCharacters:(NSString *)text;

/**
 *  获取本地的ip地址
 *
 *  @param preferIPv4 是否优先查找ipv4
 *
 *  @return 当前网络的ip地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//判断字符串是否包含
- (BOOL)cc_rangeString:(NSString *)string;

- (NSString *)cc_deleteSessionID;

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


+ (NSString *)compareCurrentTime:(NSString *)str;
+ (NSString *)numFormatNumber:(NSInteger)count;
@end
