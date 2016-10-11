//
//  EVMessageItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMessageItem.h"
#import "EVMessageItemFrame.h"

@interface EVMessageItem ()

@end

@implementation EVMessageItem

- (instancetype)initWith:(EMMessage *)message
{
    if ( self = [super init] )
    {
        self.message = message;
    }
    return self;
}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    self.ext = message.ext;
    id<IEMMessageBody> body = [message.messageBodies lastObject];
    
    NSDictionary *userInfo = [[EVEaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    NSString *sender = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
    self.messageFrom = [login isEqualToString:sender] ? CCMessageFromSend : CCMessageFromReceive ;
    
    switch ( [body messageBodyType] )
    {
        case eMessageBodyType_Text:
        {
            self.messageType = CCMessageText;
            EMTextMessageBody *textBody = (EMTextMessageBody *)body;
            self.content = [textBody text];
        }
            break;
            
        case eMessageBodyType_Image:
        {
            self.messageType = CCMessageImage;
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)body;
            self.localImagePath = imgMessageBody.localPath;
            if ( self.messageFrom ==  CCMessageFromReceive )
            {
                self.remoteImagePath = imgMessageBody.remotePath;
            }
            
        }
            break;
            
        case eMessageBodyType_Voice:
            self.messageType = CCMessageVoice;
            self.time = ((EMVoiceMessageBody *)body).duration;
            // 本地音频路径
            self.voiceLocationPath = ((EMVoiceMessageBody *)body).localPath;
            self.voiceRemotePath = ((EMVoiceMessageBody *)body).remotePath;
            break;
            
        default:
            break;
    }
    
    self.nickName = [message from];
    // TODO: icon cache
}

- (CGFloat)cellHeight
{
    if ( _cellHeight == 0 )
    {
        EVMessageItemFrame *messageFrame = [[EVMessageItemFrame alloc] init];
        [messageFrame setMessageItem:self];
    }
    return _cellHeight;
}

- (BOOL)isEqual:(id)object
{
    if ( self == object )
    {
        return YES;
    }
    if ( [object isKindOfClass:[EVMessageItem class]] )
    {
        EVMessageItem *temp = (EVMessageItem *)object;
        return [self.message.messageId isEqualToString:temp.message.messageId];
    }
    return NO;
}

- (BOOL)isRead
{
    return self.message.isRead;
}

- (MessageDeliveryState)deliveryState
{
    return self.message.deliveryState;
}

@end
