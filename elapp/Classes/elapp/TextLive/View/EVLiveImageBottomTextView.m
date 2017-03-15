//
//  EVLiveImageTextView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLiveImageBottomTextView.h"


@interface EVLiveImageBottomTextView ()

@end

@implementation EVLiveImageBottomTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}


- (void)addUpView
{
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView autoPinEdgesToSuperviewEdges];
    
    UIButton *commentButton = [[UIButton alloc] init];
    [self addSubview:commentButton];
    commentButton.titleLabel.font = [UIFont textFontB3];
    [commentButton setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:(UIControlStateNormal)];
    [commentButton setTitle:[NSString stringWithFormat:@"大师，快来直播吧～"] forState:(UIControlStateNormal)];
    [commentButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [commentButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [commentButton autoSetDimensionsToSize:CGSizeMake(150, 22)];
    [commentButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor evGlobalSeparatorColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:66];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [lineView autoSetDimensionsToSize:CGSizeMake(2, 32)];
    
    
    UIButton *sendButton = [[UIButton alloc] init];
    [self addSubview:sendButton];
    [sendButton setImage:[UIImage imageNamed:@"btn_un-send_n"] forState:(UIControlStateNormal)];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [sendButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [sendButton autoSetDimension:ALDimensionWidth toSize:64];
    [sendButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)buttonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showKeyBoardClick)]) {
        [self.delegate showKeyBoardClick];
    }
}
@end
