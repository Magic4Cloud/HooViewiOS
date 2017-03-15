//
//  EVHVChatTextView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, EVHVChatTextViewType) {
    EVHVChatTextViewTypeGift,
    EVHVChatTextViewTypeSend,
};

@protocol EVHVChatTextViewDelegate <NSObject>

- (void)chatViewButtonType:(EVHVChatTextViewType)type;

@end
@class YZInputView;
@interface EVHVChatTextView : UIView

@property (nonatomic, weak) id<EVHVChatTextViewDelegate> delegate;


@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) YZInputView *commentBtn;

@property (nonatomic, weak) UIButton *sendButton;


@property (nonatomic, weak) UIButton *giftButton;



@property (nonatomic, strong) NSLayoutConstraint *sendImageViewRig;

@property (nonatomic, strong) NSLayoutConstraint *commentBtnRig;
@end
