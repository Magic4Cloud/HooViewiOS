//
//  EVComment.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBaseObject.h"

#define CCCommentCellTopMargin 3

#define CCCommentTypeKey   @"commentType"

// 标示评论的类型
typedef NS_ENUM(NSInteger, CCCommentType) {
    CCCommentComment = 10,   // default value
    CCCommentPresent,   // 礼物提醒
    CCCommentEmoji,     // 表情提醒
    CCCommentFocus,     // 关注提醒
    CCCommentSysMsg,    // 系统消息
    CCCommentRedEnvelop // 红包提醒
};

@interface EVComment : EVBaseObject

/**
 新加的  扩展字段
 */
@property (nonatomic, strong) NSDictionary * extDic;
/** 文字起始位置 */
@property ( nonatomic ) NSInteger textOrigin;

/** 评论 id */
@property (nonatomic, assign) NSInteger comment_id;

/** 评论自定义参数 */
@property (nonatomic,copy) NSString *commentflag;

/** 当前用户登陆的名字 */
@property (nonatomic,copy) NSString *curruserLoginName;

/** 评论类型 */
@property (nonatomic, assign) CCCommentType commentType;

/** 评论显示的颜色 */
@property (nonatomic,strong) UIColor *commentBackGroundColor;

/** 评论的用户头像 */
@property (nonatomic, copy) NSString *userlogo;

/** 评论所属者的name */
@property (nonatomic,copy) NSString *name;

/** 评论回复者的昵称 */
@property (nonatomic,copy) NSString *reply_name;

/** 评论发起者的昵称 */
@property (nonatomic,copy) NSString *nickname;

/** 被回复者的呢称 */
@property (nonatomic,copy) NSString *reply_nickname;

/** 评论的内容 */
@property (nonatomic, copy) NSString *content;



/** vip和等级的合成图片 */
@property ( nonatomic, strong ) UIImage *vipAndLevelImage;

/** 0/1, //是否是游客 */
@property (nonatomic, assign) BOOL is_guest;

/** 用于显示的回复评论的昵称 */
@property (nonatomic,strong) NSString *replyNickNameString;

@property (nonatomic,assign) NSRange userNickNameRnage;
@property (nonatomic,assign) NSRange replyNikcNameRange;

@property (nonatomic,assign) CGRect usernicknameFrame;
@property (nonatomic,assign) CGRect replynickFrame;

/** 评论显示的富文本 */
@property (nonatomic,strong) NSMutableAttributedString *commentAttributeString;

/** 系统消息显示的富文本 */
@property (nonatomic,strong, readonly) NSMutableAttributedString *sysMsgCommentAttributeString;

/** 系统消息提醒红包显示的富文本 */
@property (nonatomic,strong, readonly) NSMutableAttributedString *sysMsgRedEvelopeAttributeString;

/** 关注消息显示的富文本 */
@property (nonatomic,strong, readonly) NSMutableAttributedString *focusMsgCommentAttributeString;

/** 礼物消息显示的富文本 */
@property (nonatomic,strong, readonly) NSMutableAttributedString *presentMsgCommentAttributeString;

/** 评论段落样式 */
@property (nonatomic, strong, readonly) NSDictionary *commentParagraphStyleDic;

@property ( nonatomic, strong ) NSMutableAttributedString *prefixNameAttributeString;

/** 评论cellheight */
@property (nonatomic, assign) CGFloat cellheigt;

/**
 *  评论初始化方法,socketio 传递过来的字符串
 *
 *  @param jsonString JSON 字符穿
 *
 *  @return 对象类型
 */
+ (instancetype)commentWithJSONString:(NSString *)jsonString;

- (void)updateWithCommentInfo:(NSDictionary *)info contextInfo:(NSString *)contextInfo userid:(NSString *)userid commentType:(CCCommentType)commentType;

+ (UIColor *)replyNameColor;

/**
 *
 *  获取评论内容的富文本
 *
 *  @return 评论内容的富文本
 */
- (NSMutableAttributedString *)normalCommentAttributeString;

@end
