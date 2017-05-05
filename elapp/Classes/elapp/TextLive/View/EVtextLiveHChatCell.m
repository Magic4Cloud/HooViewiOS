//
//  EVtextLiveHChatCell.m
//  elapp
//
//  Created by 唐超 on 5/3/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVtextLiveHChatCell.h"
#import "EVChatViewCell.h"
#import "EVHVChatModel.h"
#import "UIView+STFrame.h"

@interface EVtextLiveHChatCell ()

@property (nonatomic, strong) NSLayoutConstraint *rpcLabelHig;

@property (nonatomic, strong) NSLayoutConstraint *rpcLabelleft;

@property (nonatomic, strong) NSLayoutConstraint *rpcLabelright;

@property (nonatomic, strong) NSLayoutConstraint *cLabelHig;

@property (nonatomic, weak) UIButton *chatContentBtn;

@property (nonatomic, strong) EVHVChatModel *chatModel;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *tipLabel;

/**
 回复label
 */
@property (nonatomic, weak) UILabel *rpcLabel;

@property (nonatomic, weak) UILabel *contentLabel;

/**
 头像
 */
@property (nonatomic, strong) UIImageView * avatarImageView;

/**
 vip icon
 */
@property (nonatomic, strong) UIImageView * vipIConImageView;
@end

@implementation EVtextLiveHChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    //
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    tipLabel.font = [UIFont systemFontOfSize:14.];
    tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:12.];
    nameLabel.textColor = [UIColor colorWithHexString:@"#E57830"];
    self.nameLabel = nameLabel;
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.backgroundColor = [UIColor lightGrayColor];
    _avatarImageView.layer.cornerRadius = 15;
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    
    _vipIConImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_v_new"]];
    [self addSubview:_vipIConImageView];
    _vipIConImageView.hidden = YES;
    
    
    //长按button
    UIButton *chatContentBtn = [[UIButton alloc] init];
    [self addSubview:chatContentBtn];
    self.chatContentBtn = chatContentBtn;
    chatContentBtn.titleLabel.numberOfLines = 0;
    chatContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    chatContentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    chatContentBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    chatContentBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    chatContentBtn.backgroundColor = [UIColor clearColor];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    longPressGes.minimumPressDuration = 1;
    [chatContentBtn addGestureRecognizer:longPressGes];
    
    //消息内容
    UILabel *contentLabel = [[UILabel alloc] init];
    [chatContentBtn addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.hidden = YES;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont textFontB2];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor evTextColorH2];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    //回复
    UILabel *rpcLabel = [[UILabel alloc] init];
    [chatContentBtn addSubview:rpcLabel];
    self.rpcLabel = rpcLabel;
    rpcLabel.hidden = YES;
    rpcLabel.layer.cornerRadius = 4;
    rpcLabel.clipsToBounds = YES;
    rpcLabel.numberOfLines = 0;
    rpcLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rpcLabel.backgroundColor = [UIColor whiteColor];
    rpcLabel.alpha = 0.8;
    rpcLabel.textColor = [UIColor evTextColorH2];
    rpcLabel.font = [UIFont textFontB2];
    _rpcLabelleft = [rpcLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    _rpcLabelright = [rpcLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [rpcLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    self.rpcLabelHig =    [rpcLabel autoSetDimension:ALDimensionHeight toSize:0];
    
}


- (void)setMessageCellModel:(EVHVMessageCellModel *)messageCellModel
{
    _messageCellModel = messageCellModel;
    EVMessage *message = messageCellModel.message;
    
    [self.chatContentBtn setTitle:message.contentStr forState:(UIControlStateNormal)];
    self.nameLabel.frame = messageCellModel.nameF;
    
    self.chatContentBtn.frame = messageCellModel.contentF;
    self.nameLabel.text = message.nameStr;
    
    if (message.messageFrom == EVMessageFromSystem)
    {
        self.tipLabel.frame = messageCellModel.tipLabelF;
        self.tipLabel.text = message.contentStr;
        self.tipLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.chatContentBtn.hidden = YES;
    }else {
        self.tipLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.chatContentBtn.hidden = NO;
    }
    
    UIImage *normal;
    
    if (message.messageFrom == EVMessageFromMe) {
        normal = [UIImage imageNamed:@"bg_chat_myself"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(20, 22, 33, 10) ];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#E57830"];
    }else if (message.messageFrom == EVMessageFromOther){
        normal = [UIImage imageNamed:@"bg_chat_others"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 10)];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#4D9FD4"];
        
    }else {
        
    }
    [self.chatContentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    
}


/**
 聊天cell 展示
 
 */
- (void)setEaseMessageModel:(EVEaseMessageModel *)easeMessageModel
{
    _easeMessageModel = easeMessageModel;
    //    [self.chatContentBtn setTitle:easeMessageModel.text forState:(UIControlStateNormal)];
    
    NSString *content = easeMessageModel.text;
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    self.contentLabel.text = content;
    self.nameLabel.frame = easeMessageModel.nameRect;
    if ([easeMessageModel.vip boolValue] && !easeMessageModel.isSender) {
        
        CGFloat x = 0.f;
        if (!easeMessageModel.isSender) {
            x = CGRectGetMaxX(self.nameLabel.frame)-5;
            
        }
        else
        {
            x = CGRectGetMinX(self.nameLabel.frame)-19;
        }
        _vipIConImageView.frame = CGRectMake(x, 0, 22, 22);
        _vipIConImageView.hidden = NO;
        self.nameLabel.textColor = [UIColor blackColor];
//        self.nameLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        _vipIConImageView.hidden = YES;
//        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textColor = [UIColor evBackGroundDeepGrayColor];
    }
    self.avatarImageView.frame = easeMessageModel.avatarRect;
    
    //从本地取头像
    NSString * avatarUrl = [[EVImAvatarLocalClass shareInstance] getAvatarUrlWithUserid:easeMessageModel.userid];
    [self.avatarImageView cc_setImageWithURLString:avatarUrl placeholderImage:nil complete:^(UIImage *image) {
        
    }];
    
    self.chatContentBtn.frame = easeMessageModel.contentRect;
    self.nameLabel.text = easeMessageModel.nickname;
    self.tipLabel.hidden = YES;
    self.nameLabel.hidden = NO;
    self.chatContentBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    UIImage *normal;
    
    
    
    if ([easeMessageModel.vip boolValue])
    {
        //大v  背景黄色  字体黑色  回复白色
        if (easeMessageModel.isSender)
        {
            //自己发的 右边黄色（大v）
            normal = [UIImage imageNamed:@"bg_chat_myself"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(20, 22, 33, 10) ];
            self.contentLabel.textColor = [UIColor blackColor];
            self.rpcLabel.textColor = [UIColor whiteColor];
            self.rpcLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:186/255.0 blue:84/255.0 alpha:1];
        }
        else
        {
            //别人发的 左边黄色（大v）
            normal = [UIImage imageNamed:@"ic_yellow_left"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(22, 111, 22222, 22) ];
            self.contentLabel.textColor = [UIColor blackColor];
            self.rpcLabel.textColor = [UIColor whiteColor];
            self.rpcLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:186/255.0 blue:84/255.0 alpha:1];
        }
        
    }
    else
    {
        //        不是大v
        if (easeMessageModel.isSender)
        {
            //不是大v 自己发的 背景白色
            normal = [UIImage imageNamed:@"ic_White"];
            
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(20, 22, 33, 10)];
            self.contentLabel.textColor = [UIColor blackColor];
            self.rpcLabel.textColor = [UIColor blackColor];
            self.rpcLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        }
        else
        {
            //不是大v 别人发的  灰色
            normal = [UIImage imageNamed:@"bg_chat_others"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10) ];

            self.contentLabel.textColor = [UIColor blackColor];
            self.rpcLabel.textColor = [UIColor blackColor];
            self.rpcLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        }
    }
    
    if (easeMessageModel.isSender)
    {
        _rpcLabelleft.constant = 5;
        _rpcLabelright.constant = -13;
    }
    else
    {
        _rpcLabelleft.constant = 13;
        _rpcLabelright.constant = -5;
    }

    [self.chatContentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    self.rpcLabelHig.constant = easeMessageModel.rpcHig;
    self.rpcLabel.text = easeMessageModel.rpContent;
    self.rpcLabel.hidden = easeMessageModel.isReply ? NO : YES;
    self.cLabelHig.constant = easeMessageModel.cHig;
}

- (void)longPressClick:(UIGestureRecognizer *)gress
{
    if ([gress state] == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressCell:easeModel:)]) {
            [self.delegate longPressCell:self easeModel:_easeMessageModel];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
