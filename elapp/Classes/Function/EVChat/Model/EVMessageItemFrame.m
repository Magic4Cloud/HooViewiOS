//
//  EVMessageItemFrame.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVMessageItemFrame.h"
#import "EVMessageItem.h"

@implementation EVMessageItemFrame

- (void)setMessageItem:(EVMessageItem *)item
{
    CGFloat screenW = ScreenWidth;
    
    CGFloat timeMaxY = 0;
    self.timeLabelFrame = CGRectZero;
    if ( item.showTime )
    {
        CGSize size = [item.createTime sizeWithFont:MESSAGE_TIME_FONT constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat timeX = (screenW - size.width) * 0.5;
        CGFloat timeY = MESSAGE_MAGIN;
        self.timeLabelFrame = CGRectMake(timeX, timeY, size.width, size.height);
        timeMaxY = CGRectGetMaxY(self.timeLabelFrame);
    }
    
    CGFloat bodyContentY = timeMaxY + 10;
    CGFloat bodyContentX = 0;
    CGFloat contentW = 0;
    CGFloat contentH = 0;
    switch ( item.messageType )
    {
        case CCMessageText:
        {
            UILabel *label = [[UILabel alloc] init];
            label.preferredMaxLayoutWidth = MESSAGE_MAX_CONTENT_WIDTH ;
            label.numberOfLines = 0;
            label.font = MESSAGE_MESSAGE_FONT;
            label.textAlignment = NSTextAlignmentCenter;
            [label cc_setEmotionWithText:item.content];
            
            CGSize size = [label sizeThatFits:CGSizeMake(MESSAGE_MAX_CONTENT_WIDTH, MAXFLOAT)];
            
            contentW = size.width;
            contentH = size.height;
        }
            break;
          
        case CCMessageVoice:
        {
            contentH = MESSAGE_VOICE_MIN_WITDTH;
            contentW = MESSAGE_VOICE_MIN_WITDTH + item.time * 2;
            contentW = contentW > MESSAGE_MAX_CONTENT_WIDTH ? MESSAGE_MAX_CONTENT_WIDTH : contentW;
        }
            break;
         
        case CCMessageImage:
        {
            contentH = MESSAGE_IMAGE_WIDTH_HEIGHT;
            contentW = MESSAGE_IMAGE_WIDTH_HEIGHT;
        }
            break;
            
        default:
            break;
    }
    
    CGFloat headerX = 0;
    CGFloat headerY = 0;
    CGFloat textMargin = 18;
    CGFloat redEnvelopeX = 0;
    
    CGFloat bodyContentW = contentW + MESSAGE_INNER_MARGIN_LEFT + MESSAGE_INNER_MARGIN_RIGHT;
    CGFloat bodyContentH = contentH + MESSAGE_INNER_MARGIN_TOP + MESSAGE_INNER_MARGIN_BOTTOM;
    if ( item.messageFrom == CCMessageFromReceive )
    {
        headerX =  MESSAGE_MAGIN ;
        redEnvelopeX = headerX+MESSAGE_HEADER_WIDTH_HEIGHT+10;
        bodyContentX =  MESSAGE_MAGIN + MESSAGE_HEADER_WIDTH_HEIGHT + MESSAGE_BODY_LEFT;
    }
    else if ( item.messageFrom == CCMessageFromSend )
    {
        bodyContentX = screenW - bodyContentW - MESSAGE_MAGIN - MESSAGE_HEADER_WIDTH_HEIGHT - MESSAGE_BODY_LEFT;
        headerX = screenW -  MESSAGE_MAGIN - MESSAGE_HEADER_WIDTH_HEIGHT;
        redEnvelopeX = headerX-195-10;
    }
    CGFloat clearMargin = 4;  //  透明的部分高度
    headerY = bodyContentY + bodyContentH - MESSAGE_HEADER_WIDTH_HEIGHT - clearMargin;
    
    
    self.bodyContentFrame = CGRectMake(bodyContentX, bodyContentY, bodyContentW, bodyContentH);
    
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    if ( item.messageFrom == CCMessageFromSend )
    {
        contentX = 0.6 * MESSAGE_INNER_MARGIN_LEFT;
        contentY = MESSAGE_INNER_MARGIN_TOP;
        
        if ( item.messageType == CCMessageText )
        {
            contentX = textMargin;
            contentY = textMargin;
        }
        
    }
    else
    {
        contentX = MESSAGE_INNER_MARGIN_LEFT;
        contentY = MESSAGE_INNER_MARGIN_TOP;
        
        if ( item.messageType == CCMessageText )
        {
            contentX = bodyContentW - contentW - textMargin ;
            contentY = textMargin;
        }
    }
    
    self.contentFrame = CGRectMake( contentX, contentY, contentW, contentH);
    
    if ( item.messageType == CCMessageVoice )
    {
        CGFloat margin = 4;
        CGFloat containerH = contentH ;
        CGFloat containerW = contentW ;
        CGFloat x = MESSAGE_INNER_MARGIN_LEFT * 1.3;
        CGFloat w = MESSAGE_VOICE_IMAGE_WIDTH_HEIGHT;
        CGFloat h = MESSAGE_VOICE_IMAGE_WIDTH_HEIGHT;
        CGFloat y = ( contentH - h ) * 0.5;
        CGSize size = [MESSAGE_VOICE_DESC(item.time) sizeWithFont:MESSAGE_VOICE_FONT];
        CGFloat voiceDescx = x + size.width + margin;
        CGFloat voiceDescy = ( contentH - size.height ) * 0.5;
        if ( item.messageFrom == CCMessageFromReceive )
        {
            x = contentW - MESSAGE_INNER_MARGIN_LEFT * 1.3 - w;
            voiceDescx = x - margin - size.width;
            containerW += 8;
        }
        else
        {
            bodyContentX += textMargin + 23;
        }
        
        
        self.voiceLabelFrame = CGRectMake(voiceDescx, voiceDescy - 3, size.width, size.height);
        self.voiceImageFrame = CGRectMake(x, y - 3, w, h);
        self.voiceContentFrame = CGRectMake(bodyContentX, bodyContentY, containerW, containerH);
        headerY = bodyContentY + containerH - MESSAGE_HEADER_WIDTH_HEIGHT - clearMargin;
    }
    
    
   self.headerIconFrame = CGRectMake(headerX, headerY , MESSAGE_HEADER_WIDTH_HEIGHT, MESSAGE_HEADER_WIDTH_HEIGHT);
    
    if ( item.messageType == CCMessageVoice )
    {
        item.cellHeight = CGRectGetMaxY(self.voiceContentFrame);
    }
    else if ( item.messageType == CCMessageText && [item.ext.allKeys containsObject:@"redpack"])
    {
        self.headerIconFrame = CGRectMake(headerX, bodyContentY , MESSAGE_HEADER_WIDTH_HEIGHT, MESSAGE_HEADER_WIDTH_HEIGHT);
        self.redEnveloopeFrame = CGRectMake(redEnvelopeX, bodyContentY+7, 195, 80);
        item.cellHeight = bodyContentY+7+80+4;
    }
    else
    {
        item.cellHeight = CGRectGetMaxY(self.bodyContentFrame);
    }
    
    item.messageFrame = self;
}

@end
