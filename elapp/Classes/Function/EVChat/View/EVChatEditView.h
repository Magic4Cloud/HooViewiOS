//
//  EVChatEditView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVChatEditView;
@class EVChatTextView;

#define CCChatEditView_DEFAULT_HEIGHT 49

#define CCChatEditView_TAG_TOGGLE           100
#define CCChatEditView_TAG_TEXT_FACE        101
#define CCChatEditView_TAG_MORE             102
#define CCChatEditView_TAG_TAKE_PHOTO       104
#define CCChatEditView_TAG_PHOTO            105
#define CCChatEditView_TAG_SEND             107
#define CCChatEditView_TAG_SPEAK_START      108
#define CCChatEditView_TAG_SPEAK_END        109
#define CCChatEditView_TAG_SPEAK_CANCEL     110
#define CCChatEditView_TAG_SPEAK_DRAG_IN    111
#define CCChatEditView_TAG_SPEAK_DRAG_OUT   112

@protocol CCChatEditViewDelegate <NSObject>

@optional
- (void)chatEditView:(EVChatEditView *)editView keyBoardFrameDidChage:(CGRect)frame animationTime:(NSTimeInterval)time;

- (void)chatEditView:(EVChatEditView *)editView buttonDidClicked:(NSInteger)buttonType;

- (void)chatEditView:(EVChatEditView *)editView textViewShouldBeginEditing:(EVChatTextView *)textView;
- (void)chatEditView:(EVChatEditView *)editView didChange:(EVChatTextView *)textView;
- (void)sendRedEnvelope;

@end

@interface EVChatEditView : UIView

@property (nonatomic,weak) id<CCChatEditViewDelegate> delegate;

/** 如果要自适应高度，请给改属性赋值 */
@property (nonatomic,weak) NSLayoutConstraint *heightContraint;

@property (nonatomic, assign) BOOL shouldBeginEdit;

@property (nonatomic,strong) UIView *currRentAddContainView;

/** 文字颜色 */
@property ( nonatomic, strong ) UIColor *textColor;

- (void)setText:(NSString *)text;

- (NSString *)text;

- (void)resetKeyBoard;

- (void)cleanText;

- (void)backKeyBoard;

- (void)forceBackInputView;

@end
