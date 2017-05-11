//
//  EVJoinChatCell.m
//  elapp
//
//  Created by 唐超 on 5/4/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVJoinChatCell.h"
#import "EVEaseMessageModel.h"
#import "EVHVMessageCellModel.h"

@implementation EVJoinChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellAvatarImageView.layer.cornerRadius = 15;
    _cellAvatarImageView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}

/**
 视频播放下面的聊天
 */
- (void)setVideoMessageModel:(EVHVMessageCellModel *)videoMessageModel
{
    if (!videoMessageModel) {
        return;
    }
    _videoMessageModel = videoMessageModel;
    [_cellAvatarImageView cc_setImageWithURLString:videoMessageModel.avatarURLPath placeholderImage:nil];
    if (_videoMessageModel.state == EVEaseMessageTypeStateJoin) {
        NSString * name = videoMessageModel.message.nameStr;
        if (name.length>10) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:10]];
        }
        NSString * wanzhengString = [NSString stringWithFormat:@"欢迎        %@来到本直播间",name];
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:wanzhengString];
        CGRect frame = _cellAvatarImageView.frame;
        frame.origin.x = 46;
        _cellAvatarImageView.frame = frame;
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(10, name.length)];
        _cellLabel.attributedText = attributeString;
    }
    else if(_videoMessageModel.state == EVEaseMessageTypeStateGift)
    {
        NSString * name = videoMessageModel.message.nameStr;
        if (name.length>10) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:10]];
        }
        NSString * gift = videoMessageModel.message.contentStr;
        NSString * wanzhengString = [NSString stringWithFormat:@"         %@赠送给主播%@",name,gift];
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:wanzhengString];
        CGRect frame = _cellAvatarImageView.frame;
        frame.origin.x = 12;
        _cellAvatarImageView.frame = frame;
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(9, name.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(wanzhengString.length-gift.length, gift.length)];
        _cellLabel.attributedText = attributeString;
    }
}


/**
 图文直播的聊天
 */
- (void)setMessageModel:(EVEaseMessageModel *)messageModel
{
    if (!messageModel) {
        return;
    }
    
    _messageModel = messageModel;
    [_cellAvatarImageView cc_setImageWithURLString:messageModel.avatarURLPath placeholderImage:nil];
    if (_messageModel.state == EVEaseMessageTypeStateJoin) {
        NSString * name = messageModel.nickname;
        if (name.length>10) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:10]];
        }
        NSString * wanzhengString = [NSString stringWithFormat:@"欢迎        %@来到本直播间",name];
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:wanzhengString];
        CGRect frame = _cellAvatarImageView.frame;
        frame.origin.x = 46;
        _cellAvatarImageView.frame = frame;
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(10, name.length)];
        _cellLabel.attributedText = attributeString;
    }
    else if(_messageModel.state == EVEaseMessageTypeStateGift)
    {
        NSString * name = messageModel.nickname;
        if (name.length>10) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:10]];
        }
        NSString * gift = messageModel.text;
        NSString * wanzhengString = [NSString stringWithFormat:@"         %@赠送给主播%@",name,gift];
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:wanzhengString];
        CGRect frame = _cellAvatarImageView.frame;
        frame.origin.x = 12;
        _cellAvatarImageView.frame = frame;
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(9, name.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:139/255.0 blue:101/255.0 alpha:1] range:NSMakeRange(wanzhengString.length-gift.length, gift.length)];
        _cellLabel.attributedText = attributeString;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
