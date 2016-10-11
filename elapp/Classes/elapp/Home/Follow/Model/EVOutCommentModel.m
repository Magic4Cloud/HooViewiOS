//
//  EVOutCommentModel.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVOutCommentModel.h"
#import "EVLoginInfo.h"

@implementation EVOutCommentModel

+ (instancetype)commentWithReplyComment:(EVOutCommentModel *)replyComment content:(NSString *)content
{
    EVOutCommentModel *newCommentModel = [[EVOutCommentModel alloc] init];
    EVLoginInfo *currentInfo = [EVLoginInfo localObject];
    newCommentModel.name = currentInfo.name;
    newCommentModel.nickname = currentInfo.nickname;
    newCommentModel.reply_name = replyComment.name;
    newCommentModel.reply_nickname = replyComment.nickname;
    newCommentModel.content = content;
    newCommentModel.vid = replyComment.vid;
    return newCommentModel;
}


+ (instancetype)zanWithReplyComment:(EVOutCommentModel *)replyComment nickname:(NSString *)nickname
{
    EVOutCommentModel *newCommentModel = [[EVOutCommentModel alloc] init];
    EVLoginInfo *currentInfo = [EVLoginInfo localObject];
    newCommentModel.name = currentInfo.name;
    newCommentModel.nickname = nickname;
    newCommentModel.reply_name = replyComment.name;
    newCommentModel.reply_nickname = replyComment.nickname;
    newCommentModel.vid = replyComment.vid;
    return newCommentModel;
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames
{
    return @{@"id" : @"ID"};
}

- (NSAttributedString *)commentsText
{
        NSMutableString *text = [NSMutableString string];

        EVOutCommentModel *commentModel;
        
        if (commentModel.nickname == nil || [commentModel.nickname isEqualToString:@""])
        {
            return nil;
        }
        [text appendString:commentModel.nickname];
        // 添加回复者昵称
    
        // 被回复者昵称
        if ( commentModel.reply_nickname )
        {
            [text appendString:kReply];
            [text appendString:commentModel.reply_nickname];
        }
        [text appendString:@" :"];
        
        // 内容
        if ( commentModel.content )
        {
            [text appendString:commentModel.content];
        }
    // 设置段落间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 5;
    style.lineSpacing = 2;
    
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#403B37"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    // 计算评论的高度
    return attText;
}

@end



