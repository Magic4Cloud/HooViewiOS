//
//  EVComment.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//



#import "EVComment.h"
#import "NSDictionary+JSON.h"
#import "EVSDKLiveEngineParams.h"
#import "NSString+Extension.h"


#define defaultSysRedEnvelop kE_GlobalZH(@"system_red")

#define CCCommentCellInnerMargin 5
#define kCommentSysMsgColor [UIColor colorWithHexString:@"#AF86FF"]  // 紫色
#define kCommentEmojiColor [UIColor colorWithHexString:@"#AF86FF"]  // 紫色
#define kCommentPresentColor [UIColor colorWithHexString:@"#FF6469"]  // 紫色
#define kCommentRedEnvelopForeTextColor [UIColor colorWithHexString:@"#AF86FF"]  // 紫色
#define kCommentRedEnvelopLaterTextColor [UIColor colorWithHexString:@"#FB6655"]  // 紫色
#define kCommentFocusColor [UIColor colorWithHexString:@"#FFE56B"]  // 黄色
#define kCommentNickNameColor [UIColor colorWithHexString:@"#FFE56B"]

@interface EVComment ()

@end

@implementation EVComment

static NSArray *_staticColors;
static UIColor *_replyNameColor;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _commentType = CCCommentComment;
    }
    return self;
}

+ (UIColor *)replyNameColor
{
    return [UIColor colorWithHexString:@"#FB6655"];
}

+ (UIColor *)randomColor
{
    NSInteger index = arc4random_uniform(_staticColors.count);
    return _staticColors[index];
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    if ( [name integerValue] == 0 )
    {
        self.commentType = CCCommentSysMsg;
    }
    else if ( [name integerValue] == 1 )
    {
        self.commentType = CCCommentFocus;
    }
    else
    {
        self.commentType = CCCommentComment;
    }
    self.is_guest = [name cc_containString:@"g"];
}

- (void)setContent:(NSString *)content
{
    if ( content == nil || [content isKindOfClass:[NSNull class]] )
    {
        content = @"";
    }
    _content = content;
}

- (void)checkReplyComment
{
    if ( [_reply_nickname isKindOfClass:[NSNull class]] || _reply_nickname.length == 0 )
    {
        _reply_nickname = nil;
        return;  
    }
    _reply_nickname = [_reply_nickname copy];
}

+ (instancetype)commentWithJSONString:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    EVComment *comment = [self objectWithDictionary:dict];
    [comment checkReplyComment];
    return comment;
}


+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyID
{
    return @{@"id" : @"comment_id"};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNickName
{
    return @{@"nk": @"nickname"};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyReplyNickName
{
    return @{@"rnk": @"reply_nickname"};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyReplyName
{
    return @{@"rnm": @"reply_name"};
}

- (BOOL)isEqual:(id)object
{
    if ( self == object )
    {
        return YES;
    }
    else if ( [object isKindOfClass:[EVComment class]] )
    {
        EVComment *item = (EVComment *)object;
        return item.comment_id == self.comment_id;
    }
    return NO;
}

- (NSMutableAttributedString *)commentAttributeString
{
    NSMutableAttributedString *commentStr = nil;
    switch ( self.commentType )
    {
        case CCCommentComment:
            commentStr = [self normalCommentAttributeString];
            break;
        case CCCommentPresent:
            commentStr = [self presentMsgCommentAttributeString];
            break;
        case CCCommentEmoji:
            commentStr = [self emojiMsgCommentAttributeString];
            break;
        case CCCommentFocus:
            commentStr = [self focusMsgCommentAttributeString];
            break;
        case CCCommentSysMsg:
            commentStr = [self sysMsgCommentAttributeString];
            break;
        case CCCommentRedEnvelop:
            commentStr = [self sysMsgRedEvelopeAttributeString];
            break;
    }
    NSShadow *textShadow = [[NSShadow alloc] init];
    if ( self.commentType != CCCommentRedEnvelop )
    {
        textShadow.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        textShadow.shadowOffset = CGSizeMake(.5, .5);
    }
    [commentStr addAttributes:@{NSShadowAttributeName: textShadow} range:NSMakeRange(0, commentStr.length)];
    return commentStr;
}

// 获得评论的富文本
- (NSMutableAttributedString *)normalCommentAttributeString
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSMutableString *mStr = [NSMutableString string];

    NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:mStr];
    [result appendAttributedString:mAttStr];
    
    // 昵称attributeString
    NSString *prefixName = self.nickname == nil ? @"": self.nickname;
    NSMutableAttributedString *prefixNameAttributeString = [[NSMutableAttributedString alloc] initWithString:prefixName];
    self.prefixNameAttributeString = prefixNameAttributeString;
    self.userNickNameRnage = NSMakeRange(0, prefixName.length);
    [prefixNameAttributeString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"87bfff"]} range:NSMakeRange(0, prefixName.length)];
    [result appendAttributedString:prefixNameAttributeString];
    
    NSString *content = [NSString stringWithFormat:@" %@", self.content];
    // 回复别人的评论的昵称
    if ( self.reply_nickname.length )
    {
        content = [NSString stringWithFormat:@"@%@ %@", self.reply_nickname, content];
    }
    
    if ( self.content == nil )
    {
        self.content = @"";
    }
    
    NSMutableAttributedString *contentAtt = [content cc_attributStringWithLineHeight:EVBoldFont(16).lineHeight];
    [result appendAttributedString:contentAtt];
    [result addAttributes:@{NSFontAttributeName: EVBoldFont(16)} range:NSMakeRange(0, result.length)];
    self.textOrigin = mAttStr.size.width;
    return result;
}

// 系统消息
- (NSMutableAttributedString *)sysMsgCommentAttributeString
{
    NSMutableAttributedString *sysMsgAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.nickname, self.content]];
    [sysMsgAttributeString addAttributes:@{NSForegroundColorAttributeName: [UIColor evPurpleColor]} range:NSMakeRange(0, self.nickname.length)];
    [sysMsgAttributeString addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(self.nickname.length + 1, self.content.length)];
    [sysMsgAttributeString addAttribute:NSFontAttributeName value:EVBoldFont(16) range:NSMakeRange(0, sysMsgAttributeString.length)];
    return sysMsgAttributeString;
}

// 红包消息
- (NSMutableAttributedString *)sysMsgRedEvelopeAttributeString
{
    NSMutableAttributedString *sysMsgRedEvelopeAttributeString = [[NSMutableAttributedString alloc] initWithString:defaultSysRedEnvelop attributes:@{NSForegroundColorAttributeName: kCommentRedEnvelopLaterTextColor, NSFontAttributeName: EVBoldFont(15)}];
    
    return sysMsgRedEvelopeAttributeString;
}

// 礼物消息
- (NSMutableAttributedString *)presentMsgCommentAttributeString
{
    NSString *presentStr = [NSString stringWithFormat:@"%@ %@%@ ×%d", self.nickname,kE_GlobalZH(@"send_num_gift"), self.reply_nickname, [self.content intValue]];
    NSMutableAttributedString *presentStrAtt = [[NSMutableAttributedString alloc] initWithString:presentStr attributes:@{NSFontAttributeName: EVBoldFont(16), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"ff809e"]}];
    return presentStrAtt;
}

// 表情消息
- (NSMutableAttributedString *)emojiMsgCommentAttributeString
{
    NSString *presentStr = [NSString stringWithFormat:@"%@ %@%@%@ ×%d", self.nickname,kE_GlobalZH(@"send_num_gift"), self.reply_name, self.reply_nickname, [self.content intValue]];
    NSMutableAttributedString *presentStrAtt = [[NSMutableAttributedString alloc] initWithString:presentStr attributes:@{NSFontAttributeName: EVBoldFont(16), NSForegroundColorAttributeName: kCommentSysMsgColor}];
    return presentStrAtt;
}

// 关注消息
- (NSMutableAttributedString *)focusMsgCommentAttributeString
{
    NSMutableAttributedString *focusMsgAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",self.nickname, self.content] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: EVBoldFont(16)}];
    return focusMsgAttributeString;
}

- (void)updateWithCommentInfo:(NSDictionary *)info contextInfo:(NSString *)contextInfo userid:(NSString *)userid commentType:(CCCommentType)commentType
{
    self.extDic = info;
    
    self.cellheigt = 0;
    self.content = nil;
    self.comment_id = 0;
    self.is_guest = YES;
    self.name = nil;
    self.nickname = nil;
    self.reply_nickname = nil;
    self.reply_name = nil;
    self.commentAttributeString = nil;
    self.commentflag = nil;
    
    
    self.content = [NSString stringWithFormat:@"%@",contextInfo];
    self.comment_id = [[info cc_objectWithKey:EVMessageKeyID] integerValue];
    
    self.name = [NSString stringWithFormat:@"%@",userid];
    self.nickname = [info cc_objectWithKey:EVMessageKeyNk];
    self.reply_nickname = [info cc_objectWithKey:EVMessageKeyRnk];
    self.reply_name = [info cc_objectWithKey:EVMessageKeyRnm];
    self.commentflag = [info cc_objectWithKey:EVMessageKeyFl];
    if (commentType == CCCommentPresent) {
        self.reply_nickname = info[@"gnm"];
        self.content = info[@"gct"];
    }
    if (commentType == CCCommentFocus) {
        self.nickname = info[@"nickname"];
    }

    self.commentType = commentType;
    [self checkReplyComment];
    
    self.cellheigt = [self.commentAttributeString boundingRectWithSize:CGSizeMake(190, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 6;
}

@end
