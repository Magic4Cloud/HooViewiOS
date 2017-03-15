//
//  EVAudienceChatTextView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAudienceChatTextView.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVChatTextView.h"

@interface EVAudienceChatTextView () <CCChatTextViewDelegate, UITextViewDelegate>

@property (nonatomic, weak) UIButton *toggleButton;
@property ( nonatomic, copy ) NSString *reply;
@property (nonatomic, assign) BOOL resetact;

/** 评论框中文字的高度 */
@property ( nonatomic ) CGFloat textHeight;

@property (nonatomic, weak) EVChatTextView *textView;

@end

@implementation EVAudienceChatTextView

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)emptyText
{
    [self.textView resignFirstResponder];
    self.textView.placeHolderHidden = NO;
    self.textView.attributedText = nil;
    self.heightContraint.constant = CCAudienceChatTextViewHeight;
}

- (void)setUp
{
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.7];
    
    // 表情按钮
    UIButton *toggleButton = [[UIButton alloc] init];
    [self addSubview:toggleButton];
    self.toggleButton = toggleButton;

    [toggleButton setImage:[UIImage imageNamed:@"livinging_icon_face"] forState:UIControlStateNormal];
    [toggleButton setImage:[UIImage imageNamed:@"living_icon_write"] forState:UIControlStateSelected];
    [toggleButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginSide = 10;
    [toggleButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginSide - 7];
    [toggleButton autoSetDimension:ALDimensionHeight toSize:CCAudienceChatTextViewHeight];
    [toggleButton autoSetDimension:ALDimensionWidth toSize:CCAudienceChatTextViewHeight];
    
    EVChatTextView *textView = [[EVChatTextView alloc] init];
    textView.returnKeyType = UIReturnKeySend;
    textView.chatTextViewDelegate = self;
    textView.delegate = self;
    textView.placeHoder = kE_GlobalZH(@"say_what");
    textView.showSendButton = YES;
    textView.textColor = [UIColor whiteColor];
    textView.placeHoderTextColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
    textView.font = EVNormalFont(12);
    textView.textAlignment = NSTextAlignmentLeft;
    textView.backgroundColor = [UIColor clearColor];
    [self addSubview:textView];
    [textView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    [textView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toggleButton];
    [toggleButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:textView];
    self.textView = textView;
    
    [self setUpNotification];
}

- (void)setUpNotification
{
     [EVNotificationCenter addObserver:self selector:@selector(keyFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyFrameChanged:(NSNotification *)notification
{
    if ( ![self.delegate respondsToSelector:@selector(audienceChatTextKeyBarodDidChange:textFrame:animationTime:)] )
        return;
    
    NSTimeInterval animationTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.delegate audienceChatTextKeyBarodDidChange:self textFrame:keyBoardFrame animationTime:animationTime];
}

- (void)toggle:(UIButton *)button
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(audienceChatTextChangeInputStyle)] )
    {
        [self.delegate audienceChatTextChangeInputStyle];
    }
    button.selected = !button.selected;
    
    // 这样做不会出现先弹上很大一段距离再收下来的情况
    self.textView.inputView = button.selected ? self.textView.contentView : nil;
        [self.textView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

// 是否是第一响应者
- (BOOL)isFirstResponder
{
    [super isFirstResponder];
    return [self.textView isFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [textView.text numOfWordWithLimit:60] > 60 && ![text isEqualToString:@""] && ![text isEqualToString:@"\n"] )
    {
        return NO;
    }
    if ( [text isEqualToString:@"\n"] && ![textView.text isEqualToString:@""] )
    {
        [self chatTextViewSendButtonDidClicked:self.textView];
        return NO;
    }
    
    if ( [text isEqualToString:@""] &&
        [textView.text isEqualToString:self.reply] )
    {
        textView.text = @" ";
        textView.textColor = [UIColor whiteColor];
    }
    
    return YES;
}

#pragma mark - CCChatTextViewDelegate
- (void)chatTextViewSendButtonDidClicked:(EVChatTextView *)textView
{
    if ( [self.delegate respondsToSelector:@selector(audienceChatTextViewDidClickSendButton:)] )
    {
        [self.delegate audienceChatTextViewDidClickSendButton:self];
    }
    self.heightContraint.constant = CCAudienceChatTextViewHeight;
}

- (void)chatTextViewTextDidChange:(EVChatTextView *)textView
{
    self.bottomView.hidden = YES;
    NSString *text = [self.textView rawString];
    
    if ( text && text.length == 0 )
    {
        self.heightContraint.constant = CCAudienceChatTextViewHeight;
    }
    else
    {
//        CGFloat textViewHeight = [text boundingRectWithSize:CGSizeMake(textView.bounds.size.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: textView.font} context:nil].size.height;
//        if ( !self.textHeight )
//        {
//            self.textHeight = textViewHeight;
//        }
//        if ( textViewHeight != self.textHeight )
//        {
//            self.heightContraint.constant += (textViewHeight - self.textHeight);
//        }
//        self.textHeight = textViewHeight;
        
        CGSize sizeThatFits = [self.textView sizeThatFits:self.textView.frame.size];
        CGFloat newHeight = sizeThatFits.height;
        self.heightContraint.constant = newHeight;
    }
   
    if ([self.textView isFirstResponder]) {
         [self resetContentOffset];
    }else{
        self.bottomView.hidden = NO;
    }
//    [self performSelector:@selector(resetContentOffset) withObject:nil afterDelay:0.1];
    
}

- (void)resetContentOffset
{
    self.bottomView.hidden = YES;
    [self.textView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (NSString *)text
{
    return [self.textView rawString];
}

- (void)setReplyString:(NSString *)reply
{
    self.reply = reply;
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:reply attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : self.textView.font}];
    self.textView.placeHolderHidden = YES;
    [self chatTextViewTextDidChange:self.textView];
}

- (void)beginEdit
{
    [self.textView becomeFirstResponder];
}

@end
