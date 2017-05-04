//
//  EVEaseMessageModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/19.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVEaseMessageModel.h"
#import "EVLoginInfo.h"
#define ChatMargin   10


@implementation EVEaseMessageModel

/**
环信聊天 记录model生成
 */
- (instancetype)initWithChatMessage:(EMMessage *)message
{
    self = [super init];
    if (self) {
        _firstMessageBody = message.body;
        _bodyType = _firstMessageBody.type;
        _messageId = message.messageId;
        _timestamp = message.timestamp;
        _isSender = message.direction == EMMessageDirectionSend ? YES : NO;
        _fromName = message.from;
        NSDictionary *Dict = message.ext;
         [self updateMessageExtDict:Dict];
        
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeText:
            {
                EMTextMessageBody *messageBody = (EMTextMessageBody *)_firstMessageBody;
                self.text = messageBody.text;
                //如果是送礼
                if (self.state == EVEaseMessageTypeStateGift || self.state == EVEaseMessageTypeStateJoin) {
                    self.chatCellHight = 50;
                    break ;
                }
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                
                NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                              NSParagraphStyleAttributeName: paragraphStyle};
                
                
                CGFloat nameFontSize = 16.f;
                
                NSDictionary *nameAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:nameFontSize],
                                              NSParagraphStyleAttributeName: paragraphStyle};
                CGSize nameSize = [self.nickname boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:nameAttributes context:nil].size;
                CGSize contentSize = [messageBody.text boundingRectWithSize:CGSizeMake(ScreenWidth - 130, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
                self.cHig = contentSize.height+5;
                CGSize rpContetSize = [self.rpContent boundingRectWithSize:CGSizeMake(ScreenWidth - 140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                rpContetSize = CGSizeMake(rpContetSize.width+10, rpContetSize.height);
                
                CGFloat maxWid = MAX(rpContetSize.width, contentSize.width) + 20;
                CGFloat minWid = MAX(maxWid, 36)+10;
                CGFloat nameX = 56;
                CGFloat contentX = ChatMargin + 40;
                CGFloat avatarX = ChatMargin;
                if (_isSender) {
                    contentX = ScreenWidth - 40 - minWid - 10;
                    nameX = ScreenWidth - 40 - nameSize.width;
                    avatarX = ScreenWidth - ChatMargin - 30;
                }
                
                _nameRect = CGRectMake(nameX, 0, MIN(nameSize.width+5, 100), 20);
                _avatarRect = CGRectMake(avatarX, 0, 30, 30);
                CGFloat rpH =   self.isReply ? (rpContetSize.height + 20) : 0;
                self.rpcHig = rpH;
                _contentRect = CGRectMake(contentX, 23, minWid, contentSize.height + rpH + 20);
                
                _chatCellHight =  MAX(CGRectGetMaxY(_contentRect), 22) + 10+19 ;
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

/**
 从环信  聊天记录拉取信息   直播和聊天都用的这个model   (聊天)
 */
- (instancetype)initWithMessage:(EMMessage *)message
{
    self = [super init];
    if (self) {
        _firstMessageBody = message.body;
        _bodyType = _firstMessageBody.type;
        _messageId = message.messageId;
        _timestamp = message.timestamp;
         _isSender = message.direction == EMMessageDirectionSend ? YES : NO;
        NSDictionary *Dict = message.ext;
    
        [self updateMessageExtDict:Dict];
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeText:
            {
        
                EMTextMessageBody *messageBody = (EMTextMessageBody *)_firstMessageBody;
                self.text = messageBody.text;
                
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                
                 NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                               NSParagraphStyleAttributeName: paragraphStyle};
                 CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(ScreenWidth - 64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
                contentSize = CGSizeMake(contentSize.width, contentSize.height + 20);
                
                CGSize rpContentSize = CGSizeZero;
                
                rpContentSize = [_rpContent boundingRectWithSize:CGSizeMake(ScreenWidth - 89, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
                
                float addValue = 20;
                if (_rpContent.length>0) {
                    addValue = 50;
                }
                self.rpLhig = rpContentSize.height+30;
            
                self.titleSize = contentSize;

                self.cellHeight = contentSize.height+addValue+rpContentSize.height;
                
            }
                break;
            case EMMessageBodyTypeImage:
            {
                 self.state = EVEaseMessageTypeStateNor;
                EVLog(@"图片消息");
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)_firstMessageBody;
                NSData *imageData = [NSData dataWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                if (self.isSender) {
                    imageData = [NSData dataWithContentsOfFile:imgMessageBody.localPath];
                }
                if (imageData.length) {
                    self.image = [UIImage imageWithData:imageData];
                }
              
                if ([imgMessageBody.thumbnailLocalPath length] > 0) {
                    self.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                }
                
                if (self.isSender && self.image) {
                    if (self.image.size.width > ScreenWidth-60) {
                        self.imageSize = CGSizeMake(ScreenWidth - 60, (imgMessageBody.size.height * (ScreenWidth - 60))/imgMessageBody.size.width);
                    }else {
                        self.imageSize =  imgMessageBody.size;
                    }
                }else {
                    if (imgMessageBody.size.width > ScreenWidth-60) {
                        self.imageSize = CGSizeMake(ScreenWidth - 60, (imgMessageBody.size.height * (ScreenWidth - 60))/imgMessageBody.size.width);
                    }else {
                        self.imageSize =  imgMessageBody.size;
                    }
                }
               
                self.cellHeight = self.imageSize.height+44;
                
                
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}


/**
 从自己服务器拉去聊天记录
 */
- (instancetype)initWithHistoryMessage:(NSDictionary *)message
{
    self = [super init];
    if (self) {
        NSArray *payloadAry = message[@"payload"][@"bodies"];
        if (payloadAry.count > 0) {
           NSDictionary *bodies = payloadAry[0];
            self.hType = bodies[@"type"];
            self.text = bodies[@"msg"];
        }
        NSDictionary *Dict = message[@"payload"];
        [self updateMessageExtDict:Dict[@"ext"]];

        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                      NSParagraphStyleAttributeName: paragraphStyle};
        CGSize contentSize = [_text boundingRectWithSize:CGSizeMake(ScreenWidth - 64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
        
        CGSize rpContentSize = [_rpContent boundingRectWithSize:CGSizeMake(ScreenWidth - 89, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
        float addValue = 20;
        if (_rpContent.length>0) {
            addValue = 50;
        }
        self.rpLhig = rpContentSize.height;
        contentSize = CGSizeMake(contentSize.width, contentSize.height + 10);
        self.titleSize = contentSize;
        _cellHeight = contentSize.height+addValue+rpContentSize.height;
        
        self.from = message[@"from"];
        self.timestamp = [message[@"timestamp"] longLongValue];
        
    }
    return self;
}

/**
 聊天记录 model
 */
- (instancetype)initWithHistoryChatMessage:(NSDictionary *)message
{
    self = [super init];
    if (self) {
        if ([message[@"from"] isEqualToString:[EVLoginInfo localObject].name]) {
            _isSender = YES;
        }
        NSArray *payloadAry = message[@"payload"][@"bodies"];
        if (payloadAry.count > 0) {
            NSDictionary *bodies = payloadAry[0];
            self.hType = bodies[@"type"];
            self.text = bodies[@"msg"];
        }
        if ([self.hType isEqualToString:@"txt"])
        {
            NSDictionary *dict = message[@"payload"];
            [self updateMessageExtDict:dict[@"ext"]];
            CGFloat nameX = ChatMargin;
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            
            
            NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                          NSParagraphStyleAttributeName: paragraphStyle};
            
            CGSize nameSize = [self.nickname boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
            CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(ScreenWidth - 130, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
            self.cHig = ceil(contentSize.height);
            CGSize rpContetSize = [self.rpContent boundingRectWithSize:CGSizeMake(ScreenWidth - 140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
            CGFloat contentX = ChatMargin + MIN(nameSize.width+5, 100);
            
            CGFloat maxWid = MAX(rpContetSize.width, contentSize.width);
            CGFloat minWid = MAX(maxWid, 36);
            if (_isSender) {
                contentX = ScreenWidth - nameSize.width - minWid - 20;
            }
            if (_isSender) {
                nameX = ScreenWidth - ChatMargin - nameSize.width;
            }
            _nameRect = CGRectMake(nameX, 5, MIN(nameSize.width+5, 100), 22);
         
            CGFloat rpH =   self.isReply ? (rpContetSize.height + 30) : 0;
            self.rpcHig = rpH;
            _contentRect = CGRectMake(contentX, 0, minWid, ceil(contentSize.height) + rpH  + 20);
            _chatCellHight =  MAX(CGRectGetMaxY(_contentRect), 22) + 10;
        }
        else
        {
            NSDictionary *bodies = payloadAry[0];
            [UIImage gp_imageWithURlString:bodies[@"url"] comoleteOrLoadFromCache:^(UIImage *image, BOOL loadFromLocal) {
                self.image = image;
                
                if (self.image) {
                    if (self.image.size.width > ScreenWidth-60) {
                        self.imageSize = CGSizeMake(ScreenWidth - 60, (self.image.size.height * (ScreenWidth - 60))/self.image.size.width);
                    }else {
                        self.imageSize =  self.image.size;
                    }
                }
            }];
        }
      
        self.from = message[@"from"];
        self.timestamp = [message[@"timestamp"] longLongValue];
        
    }
    return self;
}

- (void)updateMessageExtDict:(NSDictionary *)dict
{
    NSString *stateStr = dict[@"tp"];
    NSString * avatar = dict[@"avatar"];
    if (avatar) {
        self.avatarURLPath = avatar;
    }
    NSString * userid = dict[@"userid"];
    if (userid) {
        self.userid = dict[@"userid"];
    }
    NSString * vip = dict[@"vip"];
    if (vip) {
        self.vip = vip;
    }
    //将用户头像存到本地
    [[EVImAvatarLocalClass shareInstance] saveAvatarWithUid:_userid avatarUrl:_avatarURLPath];
    
    if ([stateStr isEqualToString:@"nor"]) {
        self.state = EVEaseMessageTypeStateNor;
    }else if ([stateStr isEqualToString:@"hl"]) {
        self.state = EVEaseMessageTypeStateHl;
    }else if ([stateStr isEqualToString:@"st"]) {
        self.state = EVEaseMessageTypeStateSt;
    }else if ([stateStr isEqualToString:@"rp"]){
        self.state = EVEaseMessageTypeStateRp;
    }else if ([stateStr isEqualToString:@"join"])
    {
        self.state = EVEaseMessageTypeStateJoin;
    }
    else if ([stateStr isEqualToString:@"gift"])
    {
        self.state = EVEaseMessageTypeStateGift;
    }
    else {
        self.state = EVEaseMessageTypeStateNor;
    }
    if ([[dict allKeys] containsObject:@"rct"]) {
        self.rpContent = dict[@"rct"];
    }
    self.isReply = NO;
    if ([[dict allKeys] containsObject:@"rct"]) {
        NSString *rctStr = dict[@"rct"];
        if (rctStr.length>0) {
            self.isReply = YES;
        }
    }
    self.nickname =  _isSender == YES ? @"我": dict[@"nk"];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
