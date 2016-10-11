//
//  EVChatMessageCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVChatMessageCell.h"
#import "EVMessageItem.h"
#import "EVMessageItemFrame.h"
#import "UUImageAvatarBrowser.h"
#import "EVHeaderView.h"
#import "UIView+Utils.h"
#import "EVRedEnvelopeModel.h"
#import "EVPromptRedPacketView.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define IMAGE_NAME_SEND    @"chatroom_dialog_right"
#define IMAGE_NAME_RECEIVE  @"chatroom_dialog_left"

#define IMAGE_LOCATION_NAME @"chat_location_preview"

#define VOICE_UNREAD_REMARK_WIDTH 5.0f

@interface EVChatMessageCell ()

@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) CCHeaderImageView *headerImageView;
//@property (nonatomic,weak) UIButton *voiceButton;
@property (nonatomic,weak) UIImageView *thumbImageView;
@property (nonatomic,weak) UILabel *locationLabel;
@property (nonatomic,weak) UIButton *playButton;
@property (nonatomic,weak) UIImageView *voiceImg;
@property (nonatomic,weak) UILabel *voiceLabel;
@property (weak, nonatomic) UIImageView *voiceUnreadMark;
@property (weak, nonatomic) UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) UIButton *sendAgainBtn;
@property (weak, nonatomic) UIImageView *bgView;
@property ( weak, nonatomic ) CALayer *timeBgLayer;
@property ( strong, nonatomic ) UIMenuItem *cpyItem;
@property ( strong, nonatomic ) UIMenuItem *relayItem;
@property ( strong, nonatomic ) UIMenuItem *deleteItem;
@property (strong, nonnull) EVPromptRedPacketView * redEnvelopeBtn;

@end

@implementation EVChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (UIMenuItem *)cpyItem
{
    if ( _cpyItem == nil )
    {
        _cpyItem = [[UIMenuItem alloc] initWithTitle:kCopy action:@selector(cc_Copy:)];
    }
    return _cpyItem;
}

- (UIMenuItem *)relayItem
{
    if ( _relayItem == nil )
    {
        _relayItem = [[UIMenuItem alloc] initWithTitle:kForwarding action:@selector(cc_Relay:)];
    }
    return _relayItem;
}

- (UIMenuItem *)deleteItem
{
    if ( _deleteItem == nil )
    {
        _deleteItem = [[UIMenuItem alloc] initWithTitle:kDelete action:@selector(cc_Delete:)];
    }
    return _deleteItem;
}


- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer *timeBgLayer = [CALayer layer];
    [self.contentView.layer addSublayer:timeBgLayer];
    self.timeBgLayer = timeBgLayer;
    timeBgLayer.cornerRadius = 3.0f;
    timeBgLayer.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.12].CGColor;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.font = MESSAGE_TIME_FONT;
    timeLabel.textColor = [UIColor whiteColor];
    
    CCHeaderImageView *headerImageView = [[CCHeaderImageView alloc] init];
    headerImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    // 单击头像
    UITapGestureRecognizer *tapHeaderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImageView)];
    [self.headerImageView addGestureRecognizer:tapHeaderGesture];
    
    // 长按头像
    UILongPressGestureRecognizer *longPressHeaderGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHeaderView:)];
    [self.headerImageView addGestureRecognizer:longPressHeaderGesture];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
 
    // 泡泡
    UIView *bodyContentView = [[UIView alloc] init];
    [self.contentView addSubview:bodyContentView];
    self.bodyContentView = bodyContentView;
    
    UILongPressGestureRecognizer *bodyLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [bodyContentView addGestureRecognizer:bodyLongPress];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    messageLabel.preferredMaxLayoutWidth = 10;
    [self.bodyContentView addSubview:messageLabel];
    self.messageLabel = messageLabel;
    messageLabel.font = MESSAGE_MESSAGE_FONT;
    
    UIImageView *thumbImageView = [[UIImageView alloc] init];
    thumbImageView.userInteractionEnabled = YES;
    thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bodyContentView addSubview:thumbImageView];
    self.thumbImageView = thumbImageView;
    
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.font = [UIFont systemFontOfSize:11];
    locationLabel.textColor = [UIColor whiteColor];
    [thumbImageView addSubview:locationLabel];
    self.locationLabel = locationLabel;
    
    UIButton *playButton = [[UIButton alloc] init];
    playButton.hidden = YES;
    playButton.userInteractionEnabled = NO;
    [playButton setImage:[UIImage imageNamed:@"chatroom_icon_play"] forState:UIControlStateNormal];
    [thumbImageView addSubview:playButton];
    self.playButton = playButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [self.thumbImageView addGestureRecognizer:tap];
    
    UIView *voiceContainView = [[UIView alloc] init];
    [self.contentView addSubview:voiceContainView];
    self.voiceContainView = voiceContainView;
    
    UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceTap:)];
    [voiceContainView addGestureRecognizer:voiceTap];
    
    UILongPressGestureRecognizer *voiceLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [voiceContainView addGestureRecognizer:voiceLongPress];
    
    UIImageView *voiceImg = [[UIImageView alloc] init];
    [voiceContainView addSubview:voiceImg];
    self.voiceImg = voiceImg;
    
    UILabel *voiceLabel = [[UILabel alloc] init];
    voiceLabel.font = MESSAGE_VOICE_FONT;
    [voiceContainView addSubview:voiceLabel];
    self.voiceLabel = voiceLabel;
    
    UIImageView *voiceUnreadMark = [[UIImageView alloc] init];
    [voiceContainView addSubview:voiceUnreadMark];
    self.voiceUnreadMark = voiceUnreadMark;
    voiceUnreadMark.layer.cornerRadius = VOICE_UNREAD_REMARK_WIDTH / 2;
    voiceUnreadMark.layer.backgroundColor = [UIColor redColor].CGColor;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UIButton *sendAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendAgainBtn setImage:[UIImage imageNamed:@"chatroom_send_again"] forState:UIControlStateNormal];
    [self.contentView addSubview:sendAgainBtn];
    self.sendAgainBtn = sendAgainBtn;
    [sendAgainBtn addTarget:self action:@selector(sendAgainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendAgainBtn.hidden = YES;
    
    EVPromptRedPacketView * redEnvelopeBtn = [[EVPromptRedPacketView alloc] init];
    [self.contentView addSubview:redEnvelopeBtn];
    self.redEnvelopeBtn = redEnvelopeBtn;
    UITapGestureRecognizer * redEnvelopeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redEnvelopeTap)];
    [self.redEnvelopeBtn addGestureRecognizer:redEnvelopeTap];
    
}


- (void)setUpVoiceImageWithType:(CCMessageFrom)type
{
    NSMutableArray *animations = [NSMutableArray arrayWithCapacity:6];
    NSString *showImageName = type == CCMessageFromReceive ? @"chat_animation3" : @"chat_animation_white3";
    
    for ( NSInteger i = 0; i < 3; i++ )
    {
        if ( type == CCMessageFromReceive )
        {
            [animations addObject:[UIImage imageNamed:[NSString stringWithFormat:@"chat_animation%zd", i + 1]]];
        }
        else
        {
            [animations addObject:[UIImage imageNamed:[NSString stringWithFormat:@"chat_animation_white%zd", i + 1]]];
        }
    }
    self.voiceImg.image = [UIImage imageNamed:showImageName];
    self.voiceImg.animationImages = animations;
    self.voiceImg.animationDuration = 0.5;
}

- (void)setUnreadMarkWithFromType:(CCMessageFrom)type;
{
    if (self.messageItem.isRead == NO && type == CCMessageFromReceive) {
        self.voiceUnreadMark.hidden = NO;
        self.voiceUnreadMark.frame = CGRectMake(0, 0, VOICE_UNREAD_REMARK_WIDTH,VOICE_UNREAD_REMARK_WIDTH);
        self.voiceUnreadMark.center = CGPointMake(self.voiceImg.frame.origin.x + self.voiceImg.frame.size.width + VOICE_UNREAD_REMARK_WIDTH / 2, self.voiceImg.frame.origin.y - VOICE_UNREAD_REMARK_WIDTH / 2);
    }
    else
    {
        self.voiceUnreadMark.hidden = YES;
    }
}

- (void)setIndicatorViewForMessage:(MessageDeliveryState )deliveryState
{
    switch ( deliveryState ) {
        case eMessageDeliveryState_Pending:
            [self.indicatorView startAnimating];
            break;
        case eMessageDeliveryState_Delivering:
            break;

        case eMessageDeliveryState_Delivered:
            [self.indicatorView stopAnimating];
            self.sendAgainBtn.hidden = YES;
            break;

        case eMessageDeliveryState_Failure:
            [self.indicatorView stopAnimating];
            self.sendAgainBtn.hidden = NO;
            break;
    }
}

- (void)startVoiceAniamtion
{
    [self.voiceImg startAnimating];
}

- (void)stopVoiceAniamtion
{
    [self.voiceImg stopAnimating];
}

- (void)sendAgainBtnClicked:(UIButton *)button
{
    [self notifyCellEvent:CCChatMessageCell_SEND_AGAIN];
    button.hidden = YES;
}

- (void)voiceTap:(UITapGestureRecognizer *)tap
{
    CCLog(@"----voiceTap");
    [self notifyCellEvent:CCChatMessageCell_VOICE];
}

- (void)imageTap
{
    if ( [UIMenuController sharedMenuController].isMenuVisible )
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return;
    }
    if ( self.messageItem.messageType == CCMessageImage )
    {
        if ( self.thumbImageView.image )
        {
            [UUImageAvatarBrowser showImage:self.thumbImageView];
        }
        else
        {
            // TODO
        }
    }
    
}

- (void)redEnvelopeTap
{
    if ( [UIMenuController sharedMenuController].isMenuVisible )
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return;
    }
    
    self.redEnvelopeBtn.userInteractionEnabled = NO;
    NSString * imuser = @"";
    if (self.messageItem.message.messageType == eMessageTypeChat) {
        imuser = self.messageItem.nickName;
    } else {
        imuser = self.messageItem.message.groupSenderName;
    }
    
    [EVUserModel getUserInfoModelWithIMUser:imuser complete:^(EVUserModel *model) {
        if (model) {
            NSMutableDictionary * redEnvelope = [NSMutableDictionary dictionaryWithDictionary:self.messageItem.message.ext[@"redpack"]];
            [redEnvelope setObject:model.logourl forKey:@"senderAvatar"];
            [redEnvelope setObject:model.nickname forKey:@"senderName"];
            self.messageItem.message.ext = @{@"redpack": redEnvelope};
            [self notifyCellEvent:CCChatMessageCell_REDENVELOPE];
            self.redEnvelopeBtn.userInteractionEnabled = YES;
        } else {
            EVBaseToolManager * baseTool = [[EVBaseToolManager alloc] init];
            [baseTool GETUserInfoWithUname:nil orImuser:imuser start:^{
                
            } fail:^(NSError *error) {
                self.redEnvelopeBtn.userInteractionEnabled = YES;
            } success:^(NSDictionary *modelDict) {
                self.redEnvelopeBtn.userInteractionEnabled = YES;
                EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
                if (model) {
                    NSMutableDictionary * redEnvelope = [NSMutableDictionary dictionaryWithDictionary:self.messageItem.message.ext[@"redpack"]];
                    [redEnvelope setObject:model.logourl forKey:@"senderAvatar"];
                    [redEnvelope setObject:model.nickname forKey:@"senderName"];
                    self.messageItem.message.ext = @{@"redpack": redEnvelope};
                    [self notifyCellEvent:CCChatMessageCell_REDENVELOPE];
                }
            } sessionExpire:^{
                
            }];
        }
    }];
}

#pragma mark - 点击用户头像
- (void)tapHeaderImageView
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCell:didClickHeaderType:)] )
    {
        [self.delegate chatMessageCell:self didClickHeaderType:self.messageItem.messageFrom];
    }
}

- (void)longPressedHeaderView:(UILongPressGestureRecognizer *)recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateBegan )
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCell:didLongPressedHeaderType:)] )
        {
            [self.delegate chatMessageCell:self didLongPressedHeaderType:self.messageItem.messageFrom];
        }
    }
}

- (void)forceMessageContentHidden
{
    self.timeLabel.hidden = YES;
    self.messageLabel.hidden = YES;
    self.thumbImageView.hidden = YES;
    self.playButton.hidden = YES;
    self.locationLabel.hidden = YES;
    self.voiceContainView.hidden = YES;
    self.redEnvelopeBtn.hidden = YES;
}

- (void)setMessageItem:(EVMessageItem *)messageItem
{
    _messageItem = messageItem;
    [self forceMessageContentHidden];
    
    UIColor *containerColor = messageItem.messageFrom == CCMessageFromSend ? [UIColor evMainColor] : [UIColor whiteColor];
    UIColor *textColor = [UIColor evTextColorH1];
    self.messageLabel.textColor = textColor;
    self.voiceLabel.textColor = textColor;
    
    self.bodyContentView.backgroundColor = containerColor;
    
    self.bodyContentView.hidden = NO;
    
    self.timeLabel.hidden = !messageItem.showTime;
    self.timeLabel.frame = messageItem.messageFrame.timeLabelFrame;
    self.timeBgLayer.hidden = self.timeLabel.hidden;

    CGFloat xSpace = 7.0f;
    CGFloat ySpace = 3.0f;

    self.timeBgLayer.frame = CGRectMake(_timeLabel.frame.origin.x - xSpace, _timeLabel.frame.origin.y - ySpace, _timeLabel.bounds.size.width + 2 * xSpace, _timeLabel.bounds.size.height + 2 * ySpace);
    
    self.timeLabel.text = messageItem.createTime;
    self.headerImageView.hidden = NO;
    [self.headerImageView cc_setImageWithURLString:messageItem.logourl isVip:NO vipSizeType:CCVipMini];
    self.headerImageView.frame = messageItem.messageFrame.headerIconFrame;
    self.redEnvelopeBtn.frame = messageItem.messageFrame.redEnveloopeFrame;
    NSString *massageImageName = messageItem.messageFrom == CCMessageFromSend ? @"news_dialog_blue" : @"news_dialog_white";
    UIImage *maskImage = [self stretchedImageWithName:massageImageName];
    
    self.bodyContentView.frame = messageItem.messageFrame.bodyContentFrame;
    if ( messageItem.messageFrom == CCMessageFromSend )
    {
        self.indicatorView.centerY = self.bodyContentView.centerY;
        self.indicatorView.right = self.bodyContentView.left;
        [self.indicatorView startAnimating];
        [self setIndicatorViewForMessage:self.messageItem.deliveryState];
        self.sendAgainBtn.frame = self.indicatorView.frame;
    }
    else
    {
        self.indicatorView.hidden = YES;
        self.sendAgainBtn.hidden = YES;
    }
    switch ( messageItem.messageType )
    {
        case CCMessageText:{
            if (messageItem.ext && [messageItem.ext.allKeys containsObject:@"redpack"]) {
                NSDictionary * redEnvelope = [messageItem.ext objectForKey:@"redpack"];
                self.redEnvelopeBtn.hidden = NO;
                self.bodyContentView.hidden = YES;
                EVRedEnvelopeItemModel * redEnvelopeModel = [[EVRedEnvelopeItemModel alloc] init];
                NSString * imuser = @"";
                if (self.messageItem.message.messageType == eMessageTypeChat) {
                    imuser = self.messageItem.nickName;
                } else {
                    imuser = self.messageItem.message.groupSenderName;
                }
                [EVUserModel getUserInfoModelWithIMUser:imuser complete:^(EVUserModel *model) {
                    redEnvelopeModel.nickname = model.nickname;
                    redEnvelopeModel.hnm = [redEnvelope objectForKey:@"name"];
                    if (model) {
                        self.redEnvelopeBtn.model = redEnvelopeModel;
                    } else {
                        EVBaseToolManager * baseTool = [[EVBaseToolManager alloc] init];
                        [baseTool GETUserInfoWithUname:nil orImuser:imuser start:^{
                            
                        } fail:^(NSError *error) {
                            
                        } success:^(NSDictionary *modelDict) {
                            EVUserModel *model = [EVUserModel objectWithDictionary:modelDict];
                            [model updateToLocalCacheComplete:nil];
                            if (model) {
                                redEnvelopeModel.nickname = model.nickname;
                                self.redEnvelopeBtn.model = redEnvelopeModel;
                            }
                        } sessionExpire:^{
                            
                        }];
                    }
                }];
                
            } else {
                self.messageLabel.hidden = NO;
                self.messageLabel.frame = messageItem.messageFrame.contentFrame;
                [self.messageLabel cc_setEmotionWithText:messageItem.content];
            }
            break;
        }
        case CCMessageVoice:
            self.voiceContainView.hidden = NO;
            self.voiceContainView.frame = messageItem.messageFrame.voiceContentFrame;
            self.voiceImg.frame = messageItem.messageFrame.voiceImageFrame;
            self.voiceLabel.text = MESSAGE_VOICE_DESC(messageItem.time);
            self.voiceLabel.frame = messageItem.messageFrame.voiceLabelFrame;
            [self setUpVoiceImageWithType:messageItem.messageFrom];
            self.voiceContainView.backgroundColor = containerColor;
            [self setUnreadMarkWithFromType:messageItem.messageFrom];
            if (messageItem.messageFrom == CCMessageFromSend)
            {
                self.indicatorView.centerY = self.voiceContainView.centerY;
                self.indicatorView.right = self.voiceContainView.left;
                self.sendAgainBtn.frame = self.indicatorView.frame;
            }
            break;
            
      
            
        case CCMessageImage:
            self.thumbImageView.hidden = NO;
            self.thumbImageView.frame = self.bodyContentView.bounds;
            self.thumbImageView.image = messageItem.thumbImage;
            if ( messageItem.messageFrom == CCMessageFromSend )
            {
                self.thumbImageView.image = [UIImage imageWithContentsOfFile:messageItem.localImagePath];
            }
            else if ( messageItem.remoteImagePath )
            {
                [self.thumbImageView cc_setVideoThumbWithDefaultPlaceHoderURLString:messageItem.remoteImagePath];
            }
            
         
            break;
            
        default:
            break;
    }
    
    if ( messageItem.messageType == CCMessageVoice )
    {
        self.bodyContentView.hidden = YES;
        [self makeMaskView:self.voiceContainView withImage:maskImage];
    }
    else
    {
        [self makeMaskView:self.bodyContentView withImage:maskImage];
    }
}

- (UIImage *)stretchedImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];

    UIEdgeInsets insets = UIEdgeInsetsMake(35, 35,35,35);

    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)bubbleImage
{
#ifdef CCDEBUG
    assert(bubbleImage);
#endif

    // 泡泡图片
    UIImageView *bubbleIV = [[UIImageView alloc] init];
    bubbleIV.image = bubbleImage;
    
    //必须设置frame
    CGRect frame = CGRectInset(view.bounds, 1.0f, 1.0f);;
    
    bubbleIV.frame = frame;
    //不用添加成为子控件  直接设置layer就行
    view.layer.mask = bubbleIV.layer;
    //  描边
    self.bgView.frame = view.frame;
    self.bgView.image = bubbleImage;
    self.bgView.hidden = view.hidden;
}

- (void)notifyCellEvent:(NSInteger)event
{
    if ( [self.delegate respondsToSelector:@selector(chatMessageCell:didClickCellType:)] )
    {
        [self.delegate chatMessageCell:self didClickCellType:event];
    }
}

+ (NSString *)cellId
{
    return @"chatCell";
}

// 长按手势
- (void)longPressed:(UILongPressGestureRecognizer *)recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateBegan )
    {
        [self becomeFirstResponder];
        
        // 获取菜单单例对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // 获取当前行的消息类型
        CCMessageType type = self.messageItem.messageType;
        
        UIView *targetView = recognizer.view;
        CGRect rect = targetView.bounds;
        CGFloat space = 15.0f;
        [menu setTargetRect:CGRectMake(0, space, rect.size.width, rect.size.height - 2 *space) inView:targetView];
        
        // 消息为文本时有复制和删除两项,否则只有删除
        if ( type == CCMessageText || type == CCMessageImage )
        {
            menu.menuItems = @[self.cpyItem,self.relayItem,self.deleteItem];
        }
        else
        {
            menu.menuItems = @[self.relayItem,self.deleteItem];
        }
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(cc_Copy:) || action == @selector(cc_Delete:) || action == @selector(cc_Relay:)) {
        return YES;
    }
    
    return NO;
}


// 复制文字
- (void)cc_Copy:(id)sender
{
    // 获取当前行对象
    EVMessageItem *cellItem = self.messageItem;
    if ( cellItem.messageType == CCMessageText )
    {
        EMTextMessageBody *body = [cellItem.message.messageBodies lastObject];
        if ( body.text )
        {
            [[UIPasteboard generalPasteboard] setString:body.text];
        }
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:cellItem.localImagePath];
        if ( image )
        {
            [[UIPasteboard generalPasteboard] setImage:image];
        }
    }
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCell:didClickCopyMenuWithItem:)] )
    {
        [self.delegate chatMessageCell:self didClickCopyMenuWithItem:self.messageItem];
    }
}

// 转发消息
- (void)cc_Relay:(id)sender
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCell:didClickRelayMenuWithItem:)] )
    {
        [self.delegate chatMessageCell:self didClickRelayMenuWithItem:self.messageItem];
    }
}

// 删除
- (void)cc_Delete:(id)sender
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chatMessageCell:didClickDeleteMenuWithItem:)] )
    {
        [self.delegate chatMessageCell:self didClickDeleteMenuWithItem:self.messageItem];
    }
}

@end
