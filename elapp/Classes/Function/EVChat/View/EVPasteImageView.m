//
//  EVPasteImageView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPasteImageView.h"
#import <PureLayout.h>

@interface EVPasteImageView ()

@property ( copy, nonatomic)SendBtnBlock sendBlock;

@end

@implementation EVPasteImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
    // 底部图片
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView autoCenterInSuperview];
    [bgView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:32.0f];
    [bgView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:32.0f];
    [bgView autoSetDimension:ALDimensionHeight toSize:300.0f];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5.0f;
    
    UIImageView *imageBgView = [[UIImageView alloc] init];
    [bgView addSubview:imageBgView];
    [imageBgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(25, 25, 75, 25)];
    imageBgView.layer.borderColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr].CGColor;
    imageBgView.layer.borderWidth = kGlobalSeparatorHeight;
    imageBgView.image = [UIPasteboard generalPasteboard].image;
    imageBgView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    [bgView addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
    [lineView autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    lineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 按钮分割线
    UIView *buttonLineView = [[UIView alloc] init];
    [bgView addSubview:buttonLineView];
    [buttonLineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [buttonLineView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [buttonLineView autoSetDimensionsToSize:CGSizeMake(0.5f, 50)];
    buttonLineView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    
    // 按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    [bgView addSubview:cancelButton];
    [cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView];
    [cancelButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:buttonLineView];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [cancelButton setTitle:kCancel forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];

    // 发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitleColor:[UIColor colorWithHexString:kGlobalGreenColor] forState:UIControlStateNormal];
    [bgView addSubview:sendButton];
    [sendButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView];
    [sendButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:buttonLineView];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [sendButton setTitle:kSend forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(clickSend:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickCancel:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)clickSend:(UIButton *)button
{
    if ( self.sendBlock )
    {
        self.sendBlock([UIPasteboard generalPasteboard].image);
    }
    [self removeFromSuperview];
}

- (void)showPasteImageView:(SendBtnBlock)sendBlock
{
    self.sendBlock = sendBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


@end
