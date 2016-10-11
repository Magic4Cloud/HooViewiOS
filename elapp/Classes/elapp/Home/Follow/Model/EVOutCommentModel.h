//
//  EVOutCommentModel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "CCBaseObject.h"

@interface EVOutCommentModel : CCBaseObject
@property (assign, nonatomic) NSInteger ID;             /**< 评论id */
@property (copy, nonatomic) NSString *name;             /**< 评论者云播号 */
@property (copy, nonatomic) NSString *nickname;         /**< 评论者昵称 */
@property (copy, nonatomic) NSString *reply_name;       /**< 被回复者云播号 */
@property (copy, nonatomic) NSString *reply_nickname;   /**< 被回复者昵称 */
@property (copy, nonatomic) NSString *content;          /**< 评论内容 */
@property (copy, nonatomic) NSString *vid;              /**< 视频vid */
@property (copy, nonatomic) NSString *like_count;     /** 评论点赞数 */
@property (copy, nonatomic) NSString *time;             /** 评论时间*/

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *logourl;

@property (nonatomic, copy) NSString *vip;

@property (nonatomic ,assign) NSInteger isliked;
@property ( strong, nonatomic ) NSAttributedString *commentsText;/**< 评论文本 */

@property (assign, nonatomic,readonly) CGFloat contentHeight;

@property (nonatomic ,assign) NSInteger total;
/**
 *  @author 杨尚彬
 *
 *  根据被评论的模型生成一个新的评论
 *
 *  @param replyComment 被评论者
 *  @param content      评论内容
 *
 *  @return 新的评论
 */
+ (instancetype)commentWithReplyComment:(EVOutCommentModel *)replyComment content:(NSString *)content;

+ (instancetype)zanWithReplyComment:(EVOutCommentModel *)replyComment nickname:(NSString *)nickname;

@end


