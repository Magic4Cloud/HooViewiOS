//
//  EVChatViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVChatViewCell.h"
#import "EVHVChatModel.h"
#import "UIView+STFrame.h"

@interface EVChatViewCell ()

@property (nonatomic, weak) UIButton *chatContentBtn;

@property (nonatomic, strong) EVHVChatModel *chatModel;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *tipLabel;

/**
 回复label
 */
@property (nonatomic, weak) UILabel *rpcLabel;

@property (nonatomic, strong) NSLayoutConstraint *rpcLabelHig;
@property (nonatomic, strong) NSLayoutConstraint *cLabelHig;

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation EVChatViewCell

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
    UILabel *tipLabel = [[UILabel alloc] init];
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    tipLabel.font = [UIFont systemFontOfSize:14.];
    tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:16.];
    nameLabel.textColor = [UIColor colorWithHexString:@"#E57830"];
    self.nameLabel = nameLabel;
    
    
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
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [chatContentBtn addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.hidden = YES;
//    contentLabel.layer.cornerRadius = 4;
//    contentLabel.clipsToBounds = YES;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont textFontB2];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor evTextColorH2];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-5];
//    self.cLabelHig =    [contentLabel autoSetDimension:ALDimensionHeight toSize:0];
    
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
    [rpcLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [rpcLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
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
    if (message.messageFrom == EVMessageFromSystem) {
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
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
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
    self.chatContentBtn.frame = easeMessageModel.contentRect;
    self.nameLabel.text = easeMessageModel.nickname;
    self.tipLabel.hidden = YES;
    self.nameLabel.hidden = NO;
    self.chatContentBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    UIImage *normal;
    if (easeMessageModel.isSender)
    {
        normal = [UIImage imageNamed:@"bg_chat_myself"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        
        
    }
    else
    {
        normal = [UIImage imageNamed:@"bg_chat_others"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
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
