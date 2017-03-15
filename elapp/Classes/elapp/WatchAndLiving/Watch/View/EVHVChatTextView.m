//
//  EVHVChatTextView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVChatTextView.h"
#import "YZInputView.h"
#import "NSString+Extension.h"

static NSUInteger const kMaxLimitNum = 140;

@interface EVHVChatTextView ()<UITextFieldDelegate, UITextViewDelegate>


@end

@implementation EVHVChatTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundColor = [UIColor whiteColor];
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    
    UIView *vLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    vLineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self addSubview:vLineView];
  
    UIButton *giftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    giftButton.frame = CGRectMake(ScreenWidth - 51, 7, 35, 35);
    giftButton.backgroundColor = [UIColor colorWithHexString:@"#d66d6d"];
    giftButton.layer.masksToBounds = YES;
    giftButton.layer.cornerRadius = 17.5;
    giftButton.tag = EVHVChatTextViewTypeGift;
    [self addSubview:giftButton];
    self.giftButton = giftButton;
    [giftButton setImage:[UIImage imageNamed:@"btn_gift_n"] forState:(UIControlStateNormal)];
    [giftButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [giftButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [giftButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
    [giftButton autoSetDimensionsToSize:CGSizeMake(35, 35)];
    
    
    
    
    
    
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth -65, 40)];
//    contentView.layer.masksToBounds = YES;
//    contentView.layer.cornerRadius = 8;
//    contentView.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
//    contentView.layer.borderWidth = 2.f;
//    contentView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:contentView];
//    self.contentView = contentView;
    
   

    
    YZInputView *commentBtn = [[YZInputView alloc] init];
    [self addSubview:commentBtn];
    commentBtn.placeholder = @" 加入聊天吧";
//    commentBtn.frame = CGRectMake(10, 4, ScreenWidth - 119, 32);
    self.commentBtn = commentBtn;
    commentBtn.delegate = self;
    commentBtn.returnKeyType = UIReturnKeySend;
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
 self.commentBtnRig = [commentBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:119];

    commentBtn.maxNumberOfLines = 4;
    
    UIButton *sendImageView = [[UIButton alloc] init];
    sendImageView.userInteractionEnabled = YES;
    sendImageView.tag = EVHVChatTextViewTypeSend;
//    sendImageView.frame = CGRectMake(ScreenWidth - 119, 0, 54, 40);
    [sendImageView setImage:[UIImage imageNamed:@"btn_un-send_n"] forState:(UIControlStateNormal)];
    [sendImageView setImage:[UIImage imageNamed:@"btn_send_s"] forState:UIControlStateSelected];
    sendImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:sendImageView];
    self.sendButton = sendImageView;
    [sendImageView addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [sendImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [sendImageView autoSetDimension:ALDimensionHeight toSize:46];
    [sendImageView autoSetDimension:ALDimensionWidth toSize:54];
   self.sendImageViewRig =  [sendImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:65];
    
    UIView *linkView = [[UIView alloc] init];
//    linkView.frame = CGRectMake(0, 4, 2, 32); 
    linkView.backgroundColor = [UIColor evLineColor];
    [self addSubview:linkView];
    [linkView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [linkView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    [linkView autoSetDimension:ALDimensionWidth toSize:2];
    [linkView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:sendImageView];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
}
- (void)buttonClick:(UIButton *)btn
{
    NSLog(@"%@",btn);
    if (btn.tag == EVHVChatTextViewTypeSend) {
        self.sendButton.selected = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatViewButtonType:)]) {
        [self.delegate chatViewButtonType:btn.tag];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = kMaxLimitNum - comcatstr.length;
    
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatViewButtonType:)]) {
            [self.delegate chatViewButtonType:EVHVChatTextViewTypeSend];
        }
        self.sendButton.selected = NO;
        return NO;
    }
    
    if (caninputlen >= 0) {
        self.sendButton.selected = YES;
        
        if (comcatstr.length == 0) {
            self.sendButton.selected = NO;
        }
        return YES;
    }
    else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        self.sendButton.selected = NO;
        return NO;
    }
    
}

@end
