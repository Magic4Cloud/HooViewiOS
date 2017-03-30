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
                CGFloat nameX = ChatMargin;
                EMTextMessageBody *messageBody = (EMTextMessageBody *)_firstMessageBody;
                self.text = messageBody.text;
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paragraphStyle.alignment = NSTextAlignmentLeft;
                
                NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                              NSParagraphStyleAttributeName: paragraphStyle};
                CGSize nameSize = [self.nickname boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
                CGSize contentSize = [messageBody.text boundingRectWithSize:CGSizeMake(ScreenWidth - 130, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
                self.cHig = contentSize.height+5;
                CGSize rpContetSize = [self.rpContent boundingRectWithSize:CGSizeMake(ScreenWidth - 140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                CGFloat contentX = ChatMargin + MIN(nameSize.width+5, 100);
                self.rpcHig = rpContetSize.height;
                CGFloat maxWid = MAX(rpContetSize.width, contentSize.width) + 20;
                CGFloat minWid = MAX(maxWid, 36)+10;
                if (_isSender) {
                    contentX = ScreenWidth - nameSize.width - minWid - 20;
                }
                if (_isSender) {
                    nameX = ScreenWidth - ChatMargin - nameSize.width;
                }
                _nameRect = CGRectMake(nameX, 5, MIN(nameSize.width+5, 100), 22);
                
                CGFloat rpH =   self.isReply ? (rpContetSize.height + 10) : 0;
         
                _contentRect = CGRectMake(contentX, 0, minWid, ceil(contentSize.height) + rpH + 10 + 10);
                
                _chatCellHight =  MAX(CGRectGetMaxY(_contentRect), 22) + 10;
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

/**
 从环信  聊天记录拉取信息   直播和聊天都用的这个model
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
                
                self.rpLhig = rpContentSize.height;
            
                self.titleSize = contentSize;

                self.cellHeight = contentSize.height+20+rpContentSize.height;
                
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
        
        NSLog(@"contentSize:%@",NSStringFromCGSize(contentSize));
        NSLog(@"rpContentSize:%@",NSStringFromCGSize(rpContentSize));
        NSLog(@"contentSize.height:%f",contentSize.height);
        NSLog(@"_rpContent:%@",_rpContent);
        NSLog(@"_text:%@",_text);
        NSLog(@"_cellHeight:%f",_cellHeight);
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
            self.rpcHig = ceil(rpContetSize.height);
            CGFloat maxWid = MAX(rpContetSize.width, contentSize.width)+20;
            CGFloat minWid = MAX(maxWid, 36);
            if (_isSender) {
                contentX = ScreenWidth - nameSize.width - minWid - 20;
            }
            if (_isSender) {
                nameX = ScreenWidth - ChatMargin - nameSize.width;
            }
            _nameRect = CGRectMake(nameX, 5, MIN(nameSize.width+5, 100), 22);
         
            CGFloat rpH =   self.isReply ? (rpContetSize.height + 10) : 0;
            _contentRect = CGRectMake(contentX, 0, minWid, ceil(contentSize.height) + rpH + 10 + 20);
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
    
    if ([stateStr isEqualToString:@"nor"]) {
        self.state = EVEaseMessageTypeStateNor;
    }else if ([stateStr isEqualToString:@"hl"]) {
        self.state = EVEaseMessageTypeStateHl;
    }else if ([stateStr isEqualToString:@"st"]) {
        self.state = EVEaseMessageTypeStateSt;
    }else if ([stateStr isEqualToString:@"rp"]){
        self.state = EVEaseMessageTypeStateRp;
    }else {
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
