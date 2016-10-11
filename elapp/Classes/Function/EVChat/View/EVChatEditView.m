//
//  EVChatEditView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChatEditView.h"
#import <PureLayout.h>
#import "EVFaceTextView.h"
#import "EVChatTextView.h"
#import "EVVerticalLayoutButton.h"
#import "EVRedEnvelopeView.h"

#define kToolBarTextFont 15

#define TextView_MARGIN_TOP_DOWN 8

@interface EVChatEditView () <UITextViewDelegate,CCChatTextViewDelegate>

@property (nonatomic,weak) UIButton *toggleButton;
@property (nonatomic,weak) UIButton *sendButton;

@property (nonatomic,weak) EVChatTextView *textView;
@property (nonatomic,weak) UIButton *speakButton;

@property (nonatomic,weak) UIView *speakButtonContainView;

@property (nonatomic, assign) CGFloat currHeightContraint;

@property (nonatomic, assign) BOOL recordDragOutSide;


@end

@implementation EVChatEditView

- (void)dealloc
{
    [CCNotificationCenter removeObserver:self];
    _textView.inputView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
        [self setUpNotification];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.textView.text = text;
}

- (NSString *)text
{
    return [self.textView rawString];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textView.textColor = textColor;
}

- (void)setUp
{
    CGFloat margin = 11;
    //CGFloat bottomMargin = 8;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
    
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleButton.backgroundColor = [UIColor clearColor];
    toggleButton.tag = CCChatEditView_TAG_TOGGLE;
    [toggleButton setImage:[UIImage imageNamed:@"chatroom_icon_text"] forState:UIControlStateSelected];
    [toggleButton setImage:[UIImage imageNamed:@"chatroom_icon_voice"] forState:UIControlStateNormal];
    [self addSubview:toggleButton];
    self.toggleButton = toggleButton;
    [toggleButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [toggleButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    [toggleButton autoSetDimensionsToSize:CGSizeMake(CCChatEditView_DEFAULT_HEIGHT, CCChatEditView_DEFAULT_HEIGHT)];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor clearColor];
    moreButton.tag = CCChatEditView_TAG_MORE;
    [moreButton setImage:[UIImage imageNamed:@"chatroom_icon_more"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"chatroom_icon_text"] forState:UIControlStateSelected];
    [self addSubview:moreButton];
    [moreButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [moreButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toggleButton];
    
    [moreButton autoSetDimensionsToSize:CGSizeMake(CCChatEditView_DEFAULT_HEIGHT - 0.5 * margin, CCChatEditView_DEFAULT_HEIGHT )];
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceButton.backgroundColor = [UIColor clearColor];
    [faceButton setImage:[UIImage imageNamed:@"chatroom_icon_face"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"chatroom_icon_text"] forState:UIControlStateSelected];
    faceButton.tag = CCChatEditView_TAG_TEXT_FACE;
    [self addSubview:faceButton];
    [faceButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:moreButton withOffset:0];
    [faceButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toggleButton];
    [faceButton autoSetDimensionsToSize:CGSizeMake(CCChatEditView_DEFAULT_HEIGHT - 0.5 * margin, CCChatEditView_DEFAULT_HEIGHT )];
    
    
    CGFloat marginTopDown = TextView_MARGIN_TOP_DOWN;
    CGFloat textViewHeight = (CCChatEditView_DEFAULT_HEIGHT - 2 * TextView_MARGIN_TOP_DOWN);
    EVChatTextView *textView = [[EVChatTextView alloc] init];
    textView.showSendButton = YES;
    textView.chatTextViewDelegate = self;
    textView.contentView.backgroundColor = [UIColor evBackgroundColor];
    textView.delegate = self;
    textView.layer.cornerRadius = textViewHeight/2;
    [self addSubview:textView];
    textView.returnKeyType = UIReturnKeySend;
    textView.font = [UIFont systemFontOfSize:kToolBarTextFont];
    textView.placeHoder = kE_GlobalZH(@"message_have_say");
    textView.placeHoderTextColor = [UIColor evTextColorH3];
    [textView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toggleButton withOffset:0];
    [textView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:faceButton withOffset:-0.5 * margin];
    [textView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:marginTopDown];
    [textView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-marginTopDown];
    self.textView = textView;
    
    UIView *speakButtonContainView = [[UIView alloc] init];
    speakButtonContainView.clipsToBounds = YES;
    speakButtonContainView.hidden = YES;
    speakButtonContainView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    speakButtonContainView.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
    speakButtonContainView.layer.borderWidth = kGlobalSeparatorHeight;
    speakButtonContainView.layer.cornerRadius = 0.5 * textViewHeight;
    [self addSubview:speakButtonContainView];
    [speakButtonContainView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toggleButton withOffset:margin];
    [speakButtonContainView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:faceButton withOffset:-margin];
    [speakButtonContainView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toggleButton];
    [speakButtonContainView autoSetDimension:ALDimensionHeight toSize:textViewHeight];
    self.speakButtonContainView = speakButtonContainView;
    
    UIButton *speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speakButton.backgroundColor = [UIColor clearColor];
    speakButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [speakButton setImage:[UIImage imageNamed:@"chatroom_hold_voice"] forState:UIControlStateNormal];
    [speakButton setTitle:kE_GlobalZH(@"hold_say") forState:UIControlStateNormal];
    speakButton.titleLabel.font = [UIFont systemFontOfSize:kToolBarTextFont];
    [speakButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [speakButtonContainView addSubview:speakButton];
    [speakButton autoCenterInSuperview];
    [speakButton autoSetDimension:ALDimensionWidth toSize:300];
    [speakButton autoSetDimension:ALDimensionHeight toSize:40];
    
    [speakButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [speakButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [speakButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    [speakButton addTarget:self action:@selector(recordButtonDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    
    for ( UIView *subView in self.subviews )
    {
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            UIButton *btn = (UIButton *)subView;
            [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.currHeightContraint = CCChatEditView_DEFAULT_HEIGHT;
    CGFloat currRentAddContainViewHeight = ScreenWidth/375*108;
    UIView *currRentAddContainView = [[UIView alloc] init];
    currRentAddContainView.backgroundColor = self.backgroundColor;
    currRentAddContainView.frame = CGRectMake(0, 0, ScreenWidth, currRentAddContainViewHeight);
    self.currRentAddContainView = currRentAddContainView;
    currRentAddContainView.backgroundColor = [UIColor whiteColor];
    //CGFloat buttonMarign = 7;
    UIFont *buttonFont = [UIFont systemFontOfSize:ScreenWidth/375*15];
    UIColor *buttonTitleColor = [UIColor colorWithHexString:@"#999999"];
    
    // video
    
    // cameraButton
    EVVerticalLayoutButton *cameraButton = [EVVerticalLayoutButton buttonWithType:UIButtonTypeCustom];
    cameraButton.tag = CCChatEditView_TAG_TAKE_PHOTO;
    [cameraButton setTitle:kE_GlobalZH(@"message_photo") forState:UIControlStateNormal];
    cameraButton.titleLabel.font = buttonFont;
    [cameraButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"chatroom_icon_camera"] forState:UIControlStateNormal];
    [currRentAddContainView addSubview:cameraButton];
    
    // photoButton
    EVVerticalLayoutButton *photoButton = [EVVerticalLayoutButton buttonWithType:UIButtonTypeCustom];
    photoButton.tag = CCChatEditView_TAG_PHOTO;
    [photoButton setTitle:kE_Image forState:UIControlStateNormal];
    photoButton.titleLabel.font = buttonFont;
    [photoButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"chatroom_icon_photo"] forState:UIControlStateNormal];
    [currRentAddContainView addSubview:photoButton];
    

    
    
    CGFloat buttonW = ScreenWidth/375*48;
    CGRect buttonFrame = CGRectMake(0, 18, buttonW, buttonW+ScreenWidth/375*20);
    
    for (NSInteger i = 0; i < currRentAddContainView.subviews.count; i++)
    {
        UIView *subView = currRentAddContainView.subviews[i];
        buttonFrame.origin.x = ScreenWidth/375*21.5 + (buttonW+ScreenWidth/375*23) * i;
        subView.frame = buttonFrame;
        if ( [subView isKindOfClass:[UIButton class]] )
        {
            [((UIButton *)subView) addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)recordButtonDrag:(UIButton *)sender withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 25.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_DRAG_OUT];
            self.recordDragOutSide = YES;
        } else {
            // UIControlEventTouchDragOutside
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_DRAG_IN];
            self.recordDragOutSide = NO;
        } else {
            // UIControlEventTouchDragInside
        }
    }
    
}

- (void)recordButtonTouchDown:(UIButton *)btn
{
    CCLog(@"recordButtonTouchDown");
    btn.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_START];
}

- (void)recordButtonTouchUpOutside:(UIButton *)btn
{
    CCLog(@"recordButtonTouchUpOutside");
    btn.backgroundColor = [UIColor clearColor];
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_CANCEL];
    self.recordDragOutSide = NO;
}

- (void)recordButtonTouchUpInside:(UIButton *)btn
{
    CCLog(@"recordButtonTouchUpInside");
    btn.backgroundColor = [UIColor clearColor];
    if ( self.recordDragOutSide )
    {
        [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_CANCEL];
        self.recordDragOutSide = NO;
        return;
    }
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_END];
    self.recordDragOutSide = NO;
}

- (void)recordDragOutside:(UIButton *)btn
{
    CCLog(@"recordDragOutside");
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_DRAG_OUT];
}

- (void)recordDragInside:(UIButton *)btn
{
    CCLog(@"recordDragInside");
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_DRAG_IN];
}

- (void)speakStart:(UIButton *)btn
{
    btn.backgroundColor = [UIColor clearColor];
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_START];
}

- (void)speakEnd:(UIButton *)btn
{
    btn.backgroundColor = [UIColor clearColor];
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_END];
}

- (void)speakCancel:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    [self buttonClickWithTag:CCChatEditView_TAG_SPEAK_CANCEL];
}

- (void)buttonDidClicked:(UIButton *)button
{
    // 1.退出第一响应者，收回键盘，显示textView，隐藏录音
    self.textView.hidden = NO;
    self.speakButtonContainView.hidden = YES;
    [self.textView resignFirstResponder];
    
    // 2.如果上一个按钮不是当前按钮，把上一个按钮的状态改为normal，改变上一个按钮的图片
    static UIButton *lastBtn = nil;
    if ( lastBtn && lastBtn != button )
    {
        lastBtn.selected = NO;
    }
    
    // 3.根据不同的button执行不同的变化
    switch ( button.tag )
    {
        case CCChatEditView_TAG_TOGGLE:
        {
            // 语音按钮
            // 选中状态，显示录音按钮，收回键盘
            // 非选中状态，显示正常键盘
            button.selected = !button.selected;
            self.textView.hidden = button.selected;
            if ( !button.selected )
            {
                [self.textView becomeFirstResponder];
            }
            else
            {
                [self resetKeyBoard];
            }
            self.speakButtonContainView.hidden = !button.selected;
            self.heightContraint.constant = (button.selected ? CCChatEditView_DEFAULT_HEIGHT:  self.currHeightContraint );
            
        }
            break;
            
        case CCChatEditView_TAG_TEXT_FACE:
            // 表情键盘
            // 根据是否为选中状态改变
            button.selected = !button.selected;
            self.textView.inputView = button.selected ? self.textView.contentView : nil;
            [self.textView becomeFirstResponder];
            break;
            
        case CCChatEditView_TAG_MORE:
            button.selected = !button.selected;
            self.textView.inputView = button.selected ? self.currRentAddContainView : nil;
            [self.textView becomeFirstResponder];
            break;
    
            
        default:
            break;
    }
    [self buttonClickWithTag:button.tag];
    lastBtn = button;
}

// 展示红包界面
- (void)showRedEnvelopeView
{
    EVRedEnvelopeItemModel *envelopeModel = [[EVRedEnvelopeItemModel alloc] init];
    EVRedEnvelopeView *redEnvelopeView = [[EVRedEnvelopeView alloc] init];
    redEnvelopeView.grabRedEnveloCompleteHandler = ^(EVRedEnvelopeView *redEnvelopView, NSInteger ecoin) {
    };
    redEnvelopeView.currentModel = envelopeModel;
    [redEnvelopeView buttonShow];
}

- (void)cleanText
{
    self.textView.attributedText = nil;
    [CCNotificationCenter postNotificationName:UITextViewTextDidChangeNotification object:self.textView userInfo:nil];
}

- (void)setUpNotification
{
    [CCNotificationCenter addObserver:self selector:@selector(keyFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [CCNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)resetKeyBoard
{
    [self.textView resignFirstResponder];
    self.shouldBeginEdit = NO;
    if ( self.textView.inputView == self.currRentAddContainView )
    {
        self.textView.inputView = nil;
    }
}

- (void)textChanged
{
    CGSize sizeThatFits = [self.textView sizeThatFits:self.textView.frame.size];
    CGFloat newHeight = sizeThatFits.height;
    self.currHeightContraint = newHeight + 2 * TextView_MARGIN_TOP_DOWN;
    self.heightContraint.constant = self.currHeightContraint;
    [self.textView setContentOffset:CGPointZero animated:YES];
}

- (void)keyFrameChanged:(NSNotification *)notification
{
    CCLog(@"####-----%d,----%s-----%@---####",__LINE__,__FUNCTION__,notification.userInfo);
    if ( ![self.delegate respondsToSelector:@selector(chatEditView:keyBoardFrameDidChage:animationTime:)] ) return;
    CCLog(@"####-----%d,----%s-----%zd---####",__LINE__,__FUNCTION__,self.textView.isFirstResponder);

    NSTimeInterval animationTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.delegate chatEditView:self keyBoardFrameDidChage:keyBoardFrame animationTime:animationTime];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    EVChatTextView *chatTextView = (EVChatTextView *)textView;
    if ( [self.delegate respondsToSelector:@selector(chatEditView:textViewShouldBeginEditing:)] )
    {
        [self.delegate chatEditView:self textViewShouldBeginEditing:chatTextView];
    }
    self.shouldBeginEdit = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self resetKeyBoard];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ( text.length == 0 )
    {
        return YES;
    }
    else if ( [text isEqualToString:@"\n"] )
    {
        [self comfirmDidClicked];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    EVChatTextView *chatTextView = (EVChatTextView *)textView;
    if ( self.delegate && [self.delegate respondsToSelector:@selector(chatEditView:didChange:)] )
    {
        [self.delegate chatEditView:self didChange:chatTextView];
    }
}

- (void)comfirmDidClicked
{
    [self chatTextViewSendButtonDidClicked:self.textView];
    [self cleanText];
}

#pragma mark - CCChatTextViewDelegate
- (void)chatTextViewSendButtonDidClicked:(EVChatTextView *)textView
{
    [self buttonClickWithTag:CCChatEditView_TAG_SEND];
    [self cleanText];
}

- (void)buttonClickWithTag:(NSInteger)tag
{
    if ( [self.delegate respondsToSelector:@selector(chatEditView:buttonDidClicked:)] )
    {
        [self.delegate chatEditView:self buttonDidClicked:tag];
    }
}

- (void)backKeyBoard
{
    [self.textView resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    
    return [self.textView becomeFirstResponder];
}

- (void)forceBackInputView
{
    self.textView.inputView = nil;
}

@end
