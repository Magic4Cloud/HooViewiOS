//
//  NSString+Extension.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "EVTextAttachment.h"
#import "EVEmojiTool.h"
#import "NSString+Emoji.h"
#import <sys/utsname.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSString (Extension)

- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSUInteger)wordCount
{
    NSUInteger words = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString: self];
    
    // Look for spaces, tabs and newlines
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    while ([scanner scanUpToCharactersFromSet:whiteSpace  intoString:nil])
        words++;
    
    return words;
}

- (BOOL)cc_containString:(NSString *)subString {
    return [self rangeOfString:subString].length != 0;
}

- (NSString *)cc_rawStringToEmojiString {
    return [self stringByReplacingEmojiCheatCodesWithUnicode];
}

- (NSString *)cc_emojiStringToRawString {
    return [self stringByReplacingEmojiUnicodeWithCheatCodes];
}

- (NSMutableAttributedString *)cc_attributStringWithLineHeight:(CGFloat)lineHeight {
    return [EVEmojiTool attributStringByString:self lineHeight:lineHeight];
}

- (NSAttributedString *)attributeStringWithReplaceRange:(NSRange)range replaceImage:(NSString *)imageName textColor:(UIColor *)color font:(UIFont *)font {
    if ( !self || [self isEqualToString:@""] )
    {
        return nil;
    }
    UIColor *strColor = color;
    UIFont *strFont = font;
    NSRange tempRange = NSMakeRange(0, 1);
    if ( !color )
    {
        strColor = [UIColor blackColor];
    }
    if ( !font )
    {
        strFont = [UIFont systemFontOfSize:14.0f];
    }
    if ( range.location < self.length && range.length < self.length && range.length != 0 )
    {
        tempRange = range;
    }
    NSDictionary *attrsDict = [NSDictionary dictionaryWithObjectsAndKeys:strFont, NSFontAttributeName, strColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attrsDict];
    EVTextAttachment *textAttachment = [[EVTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *image = [UIImage imageNamed:imageName];
    textAttachment.image = image;
    [newAttrStr replaceCharactersInRange:tempRange withAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    return [newAttrStr mutableCopy];
}

- (NSString *)thousandsSeparatorString
{
    long count = self.length;
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    NSString *  separatorString = [NSString stringWithFormat:@"%@",newstring];
    return separatorString;
}

+ (NSString *)shortNumber:(NSUInteger)count
{
    if ( count < 100000 )    // 小于1万的
    {
        if (count <= 0) {
            return [NSString stringWithFormat:@"0"];
        }else {
             return [NSString stringWithFormat:@"%ld", count];
        }
       
    }
    else if ( count < 100000000 )   // 万
    {
        // 去除千以后的尾数
        count -= count % 1000;
        
        // 判断千位数是否为0
        if ( count % 10000 == 0 )
        {
            return [NSString stringWithFormat:@"%ld 万", count / 10000];
        }
        else
        {
            return [NSString stringWithFormat:@"%.1f 万", count / 10000.0f];
        }
    }
    else    // 亿
    {
        // 去除千万以后的尾数
        count -= count % 10000000;
        
        // 判断千万位数是否为0
        if ( count % 100000000 == 0 )
        {
            return [NSString stringWithFormat:@"%ld 亿", count / 100000000];
        }
        else
        {
            NSLog(@"------ %.1f",count / 100000000.0f);
            return [NSString stringWithFormat:@"%.1f 亿", count / 100000000.0f];
        }
    }
}



+ (NSString *)timeStampWithStopSpan:(NSUInteger)stopSpan stopTime:(NSString *)stopTime {
    NSString *stamp = nil;
    if (stopSpan / (60 * 60 * 24 * 365))
    {
        stamp = [NSString stringWithFormat:@"%lu%@", stopSpan / (60 * 60 * 24 * 365),kE_GlobalZH(@"years_ago")];
    }
    else if (stopSpan / (60 * 60 * 24 * 30))
    {
        stamp = [NSString stringWithFormat:@"%ld%@", stopSpan / (60 * 60 * 24 * 30),kE_GlobalZH(@"month_ago")];
    }
    else if (stopSpan / (60 * 60 * 24 * 7))
    {
        stamp = [NSString stringWithFormat:@"%ld%@", stopSpan / (60 * 60 * 24 * 7),kE_GlobalZH(@"week_ago")];
    }
    else if (stopSpan / (60 * 60 * 24))
    {
        stamp = [NSString stringWithFormat:@"%ld%@", stopSpan / (60 * 60 * 24),kE_GlobalZH(@"day_ago")];
    }
    else if (stopSpan / (60 * 60))
    {
        stamp = [NSString stringWithFormat:@"%ld%@", stopSpan / (60 * 60),kE_GlobalZH(@"hour_ago")];
    }
    else if (stopSpan / 60)
    {
        stamp = [NSString stringWithFormat:@"%ld%@", stopSpan / 60,kE_GlobalZH(@"minute_ago")];
    }
    else
    {
        stamp = kE_GlobalZH(@"just_ago");
    }
    return stamp;
}

+ (NSString *)dateTimeStampWithStoptime:(NSString *)stopTime {
    NSString *shorTime = [stopTime substringToIndex:10];
    return shorTime;
}

- (NSString *)translateDateToForm:(NSString *)dateFormat {
    NSString *outputDateString = nil;
    // 服务器格式："2015-06-26 21:49:21"
    if (self) {
        NSString *originalFormat = @"YYYY-MM-dd HH:mm:ss";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = originalFormat;
        NSDate *originalDate = [formatter dateFromString:self];
        
        if (dateFormat) {
            NSString *outputFormat = [dateFormat copy];
            formatter.dateFormat = outputFormat;
            outputDateString = [formatter stringFromDate:originalDate];
        }
    }
    return outputDateString;
}
- (NSUInteger)numEnglishWord
{
    NSUInteger numOfWord = 0;
    NSUInteger j = 0;           // 统计2个英文字符
    for ( NSUInteger i = 0; i < self.length; i++  )
    {
        NSString *onewordStr = [self substringWithRange:NSMakeRange(i, 1)];
        const char *onewordChar = [onewordStr cStringUsingEncoding:NSASCIIStringEncoding];
        if ( onewordChar )  // 如果是英文，j+1，当j = 2时，字数+1，并把j置为0
        {
            j++;
            if ( 5 == j )
            {
                numOfWord += 1;
                j = 0;
            }
        }
        else
        {
            numOfWord += 1;
        }
    }
    return numOfWord;
}
- (NSUInteger)numOfWordWithLimit:(NSInteger)limit
{
    NSUInteger numOfWord = 0;
    NSUInteger j = 0;           // 统计2个英文字符
    for ( NSUInteger i = 0; i < self.length; i++  )
    {
        NSString *onewordStr = [self substringWithRange:NSMakeRange(i, 1)];
        const char *onewordChar = [onewordStr cStringUsingEncoding:NSASCIIStringEncoding];
        if ( onewordChar )  // 如果是英文，j+1，当j = 2时，字数+1，并把j置为0
        {
            if (limit && numOfWord >= limit)
            {
                numOfWord += 1;
                j = 0;
            }
            else
            {
                j++;
                if ( 2 == j )
                {
                    numOfWord += 1;
                    j = 0;
                }
            }
        }
        else
        {
            numOfWord += 1;
        }
    }
    return numOfWord;
}

- (NSUInteger)stringToIndexLength:(NSInteger)length
{
    NSUInteger toIndex = 0;
    NSUInteger charLength = 0;
    NSUInteger j = 0;
    for (NSUInteger i = 0;i < self.length; i++) {
        NSString *onewordStr = [self substringWithRange:NSMakeRange(i, 1)];
        const char *onewordChar = [onewordStr cStringUsingEncoding:NSASCIIStringEncoding];
        if ( onewordChar )
        {
            if (j == 1) {
                toIndex += 2;
                charLength += 1;
                j = 0;
            }else{
                j += 1;
            }
        }
        else
        {
            toIndex += 1;
            charLength += 1;
            j = 0;
        }
        if (charLength >= 10) {
            break;
        }
    }
    return toIndex;
}

- (BOOL)isNotEmpty
{
    if ( (![self isKindOfClass:[NSString class]]) )
    {
        return NO;
    }
    
    if ( ([self isEqualToString:@""]) )
    {
        return NO;
    }
    
    return  YES;
}

+ (NSString *)stringFormattedTimeFromSeconds:(double *)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:*seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

+ (NSString *)stringFormattedTimeWithNoHHFromSeconds:(double *)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:*seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"mm:ss"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

- (NSString *)convertToMinuteString:(NSInteger)sec {
    if (sec <= 0) {
        return @"00:00";
    } else {
        NSInteger seconds;
        NSInteger minutes;
        if (sec < 3600) {
            seconds = sec % 60;
            minutes = (sec / 60) % 60;
        } else {
            seconds = sec % 60;
            minutes = sec / 60;
        }
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
}

+ (NSString *)stringFormattedTimeFromDuration:(NSNumber *)duration
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[duration doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"HH : mm : ss"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

- (NSString *)base64Encoding{
    NSData *base64Data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [base64Data base64EncodedStringWithOptions:0];
}

- (NSString *)base64Decoding
{
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
}

- (NSString *)base64DecodingSuitEncoding
{
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSStringEncoding encoding = [NSString stringEncodingForData:base64Data encodingOptions:NULL convertedString:NULL usedLossyConversion:NULL];
    return [[NSString alloc] initWithData:base64Data encoding:encoding];
}

+ (NSString *)clockTimeDurationWithSpan:(NSInteger)duration
{
    NSInteger hour = duration % 86400 / 3600;
    NSInteger min = duration % 3600 / 60;
    NSInteger second = duration % 60;
    
    NSMutableString *time = [NSMutableString string];
    
    if ( hour != 0 )
    {
        [time appendFormat:@"%02ld:", (long)hour];
    }
    [time appendFormat:@"%02ld:", (long)min];
    [time appendFormat:@"%02ld", (long)second];
    
    return time;
}

+ (NSString *)stringWithWatchingCount:(NSInteger)watchingCount
{
    
    return [NSString stringWithFormat:@"%@人", [self shortNumber:watchingCount]];
    
}

+ (NSString *)floatNumberWithNumber:(NSInteger)count
{
    NSMutableString *str = [NSMutableString string];
    if ( count < 10000 )
    {
        [str appendFormat:@"%ld", count];
    }
    else
    {
        NSInteger w = count / 10000;
        NSInteger t = ( count - w * 10000 ) / 1000;
        if ( t )
        {
            [str appendFormat:@"%ld.%ldw", w, t];
        }
        else
        {
            [str appendFormat:@"%ldw",w];
        }
    }
    return str;
}

+ (NSString *)convertDistanceNumber:(NSUInteger)distance
{
    if ( distance < 1000 )    // 小于1000的
    {
        return [NSString stringWithFormat:@"%ldm", distance];
    }
    else if ( distance < 10000000 )   // km
    {
        // 去除百以后的尾数
        distance -= distance % 100;
        
        // 判断千位数是否为0
        if ( distance % 1000 == 0 )
        {
            return [NSString stringWithFormat:@"%ldkm", distance / 1000];
        }
        else
        {
            return [NSString stringWithFormat:@"%.1fkm", distance / 1000.0f];
        }
    }
    else    // 万km
    {
        // 去除千万以后的尾数
        distance -= distance % 10000000;
        
        // 判断千万位数是否为0
        if ( distance % 10000000 == 0 )
        {
            return [NSString stringWithFormat:@"%ld万km", distance / 10000000];
        }
        else
        {
            return [NSString stringWithFormat:@"%.1f万km", distance / 10000000.0f];
        }
    }
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (!string)
    {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        return YES;
    }
    
    if (string == NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)deleteSpace
{
    NSString *deleteSide = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *deleteMiddle = [deleteSide stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deleteMiddle;
}
+ (NSString *)judConstellationDateStr:(NSString *)dateStr
{
    
    NSString *retStr=@"";
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSString *birthday = [dateFormat stringFromDate:date];
    
    NSString *birthMonth = [birthday substringWithRange:NSMakeRange(5, 2)];
    
    NSString *birthDay = [birthday substringWithRange:NSMakeRange(8, 2)];
    
    int i_month = [birthMonth intValue];
    
    int i_day = [birthDay intValue];
    
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=kE_GlobalZH(@"e_aquarius");
            }
            if(i_day>=1 && i_day<=19){
                retStr=kE_GlobalZH(@"e_capricornus");
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=kE_GlobalZH(@"e_aquarius");
            }
            if(i_day>=19 && i_day<=31){
                retStr=kE_GlobalZH(@"e_pisces");
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=kE_GlobalZH(@"e_pisces");
            }
            if(i_day>=21 && i_day<=31){
                retStr=kE_GlobalZH(@"e_aries");
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=kE_GlobalZH(@"e_aries");
            }
            if(i_day>=20 && i_day<=31){
                retStr=kE_GlobalZH(@"e_taurus");
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=kE_GlobalZH(@"e_taurus");
            }
            if(i_day>=21 && i_day<=31){
                retStr=kE_GlobalZH(@"e_gemini");
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=kE_GlobalZH(@"e_gemini");
            }
            if(i_day>=22 && i_day<=31){
                retStr=kE_GlobalZH(@"e_cancer");
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=kE_GlobalZH(@"e_cancer");
            }
            if(i_day>=23 && i_day<=31){
                retStr=kE_GlobalZH(@"e_leo");
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=kE_GlobalZH(@"e_leo");
            }
            if(i_day>=23 && i_day<=31){
                retStr=kE_GlobalZH(@"e_virgo");
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=kE_GlobalZH(@"e_virgo");
            }
            if(i_day>=23 && i_day<=31){
                retStr=kE_GlobalZH(@"e_libra");
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=kE_GlobalZH(@"e_libra");
            }
            if(i_day>=24 && i_day<=31){
                retStr=kE_GlobalZH(@"e_scorpio");
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=kE_GlobalZH(@"e_scorpio");
            }
            if(i_day>=22 && i_day<=31){
                retStr=kE_GlobalZH(@"e_sagittarius");
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=kE_GlobalZH(@"e_sagittarius");
            }
            if(i_day>=21 && i_day<=31){
                retStr=kE_GlobalZH(@"e_capricornus");
            }
            break;
            
        default:
            {
                retStr =kE_GlobalZH(@"e_gemini");
            }
            break;
    }
    return retStr;
    
}
+ (NSString *)ageFromDateStr:(NSString *)dateStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSString *birthday = [dateFormat stringFromDate:date];
    
    int birthYear = [[birthday substringWithRange:NSMakeRange(0, 4)] intValue];
    
    int birthMonth = [[birthday substringWithRange:NSMakeRange(5, 2)] intValue];
    
    int birthDay = [[birthday substringWithRange:NSMakeRange(8, 2)] intValue];
    
    NSDate *nowDate = [NSDate date];
    
    NSString *now = [dateFormat stringFromDate:nowDate];
    
    int nowYear = [[now substringWithRange:NSMakeRange(0, 4)] intValue];
    
    int nowMonth = [[now substringWithRange:NSMakeRange(5, 2)] intValue];
    
    int nowDay = [[now substringWithRange:NSMakeRange(8, 2)] intValue];
    
    int yearCha = nowYear-birthYear;
    int age;
    if (nowMonth < birthMonth) {
        yearCha--;
        age = yearCha;
    } else if (nowMonth == birthMonth) {
        if (nowDay < birthDay) {
            yearCha--;
            age = yearCha;
        } else {
            age = yearCha;
        }
    } else {
        age = yearCha;
    }
    
    if (dateStr == nil || [dateStr isEqualToString:@""] || [dateStr isEqualToString:@"0000-00-00"]) {
        age = 20;
    }
    return [NSString stringWithFormat:@"%d",age];
}
+ (instancetype)stringWithArray:(NSArray<NSString *> *) strArray
{
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < strArray.count; i ++)
    {
        NSString *str = [strArray objectAtIndex:i];
        [resultStr appendString:str];
        if ( i != (NSInteger)strArray.count - 1 )
        {
            [resultStr appendString:@","];
        }
    }
    return resultStr;
}

+ (BOOL)isBeautyFaceAvailable
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return NO;
    if ([platform isEqualToString:@"iPhone1,2"]) return NO;
    if ([platform isEqualToString:@"iPhone2,1"]) return NO;
    if ([platform isEqualToString:@"iPhone3,1"]) return NO;
    if ([platform isEqualToString:@"iPhone3,2"]) return NO;
    if ([platform isEqualToString:@"iPhone3,3"]) return NO;
    if ([platform isEqualToString:@"iPhone4,1"]) return NO;
    if ([platform isEqualToString:@"iPhone5,1"]) return NO;
    if ([platform isEqualToString:@"iPhone5,2"]) return NO;
    if ([platform isEqualToString:@"iPhone5,3"]) return NO;
    if ([platform isEqualToString:@"iPhone5,4"]) return NO;
    if ([platform isEqualToString:@"iPhone6,1"]) return YES;
    if ([platform isEqualToString:@"iPhone6,2"]) return YES;
    if ([platform isEqualToString:@"iPhone7,1"]) return YES;
    if ([platform isEqualToString:@"iPhone7,2"]) return YES;
    if ([platform isEqualToString:@"iPhone8,1"]) return YES;
    if ([platform isEqualToString:@"iPhone8,2"]) return YES;
    
    if ([platform isEqualToString:@"iPod1,1"])   return NO;
    if ([platform isEqualToString:@"iPod2,1"])   return NO;
    if ([platform isEqualToString:@"iPod3,1"])   return NO;
    if ([platform isEqualToString:@"iPod4,1"])   return NO;
    if ([platform isEqualToString:@"iPod5,1"])   return NO;
    
    if ([platform isEqualToString:@"iPad1,1"])   return NO;
    if ([platform isEqualToString:@"iPad2,1"])   return NO;
    if ([platform isEqualToString:@"iPad2,2"])   return NO;
    if ([platform isEqualToString:@"iPad2,3"])   return NO;
    if ([platform isEqualToString:@"iPad2,4"])   return NO;
    if ([platform isEqualToString:@"iPad2,5"])   return NO;
    if ([platform isEqualToString:@"iPad2,6"])   return NO;
    if ([platform isEqualToString:@"iPad2,7"])   return NO;
    
    if ([platform isEqualToString:@"iPad3,1"])   return NO;
    if ([platform isEqualToString:@"iPad3,2"])   return NO;
    if ([platform isEqualToString:@"iPad3,3"])   return NO;
    if ([platform isEqualToString:@"iPad3,4"])   return NO;
    if ([platform isEqualToString:@"iPad3,5"])   return NO;
    if ([platform isEqualToString:@"iPad3,6"])   return NO;
    
    if ([platform isEqualToString:@"iPad4,1"])   return YES;
    if ([platform isEqualToString:@"iPad4,2"])   return YES;
    if ([platform isEqualToString:@"iPad4,3"])   return YES;
    if ([platform isEqualToString:@"iPad4,4"])   return YES;
    if ([platform isEqualToString:@"iPad4,5"])   return YES;
    if ([platform isEqualToString:@"iPad4,6"])   return YES;
    
    return YES;
}
+(BOOL)isPureNumandCharacters:(NSString *)text{
    for(int i = 0; i < [text length]; i++) {
        int a = [text characterAtIndex:i];
        if (isdigit(a)) {
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}


#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

- (BOOL)isIPV4
{
    return YES;
}

- (BOOL)cc_rangeString:(NSString *)string
{
    return [self rangeOfString:string].location != NSNotFound ? YES : NO;
}

- (NSString *)cc_deleteSessionID
{
    NSString *paramStr = nil;
    NSArray *array = [self componentsSeparatedByString:@"?"]; //从字符A中分隔成2个元素的数组
    paramStr = array[1];
    if ([array[1] cc_rangeString:@"="]) {
    
        paramStr = array[1];
    }else{
        paramStr =  array[0];
    }
    NSArray *paramArray = [paramStr componentsSeparatedByString:@"&"];
    NSMutableArray *operMutableArray = [NSMutableArray arrayWithArray:paramArray];
    for (NSUInteger i = 0; i < paramArray.count; i++) {
        if ([paramArray[i] hasPrefix:@"sessionid"]) {
            [operMutableArray removeObjectAtIndex:i];
            break;
        }
    }
    NSString *ns =[operMutableArray componentsJoinedByString:@"&"];
    return operMutableArray.count == 0 ? [NSString stringWithFormat:@"%@",array[0]] : [NSString stringWithFormat:@"%@?%@",array[0],ns];
}


// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}


+ (NSString *)compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = - timeInterval;
    //标准时间和北京时间差8个小时
    //    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else {
        result = [NSString stringWithFormat:@"%@/%@ %@",[str substringWithRange:NSMakeRange(5, 2)],[str substringWithRange:NSMakeRange(8, 2)],[str substringWithRange:NSMakeRange(11, 5)]];
    }
    
    return  result;
}
+ (NSString *)numFormatNumber:(NSInteger)count
{
    NSString *string;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithInteger:count]];
//    if (count.length <= 3) {
//        string = count;
//    }else {
//        NSNumberFormatter
//        for (NSInteger i = 0; i < (count.length / 3); i++) {
//            
//        }
//    }
//    
    return string;
}
@end
