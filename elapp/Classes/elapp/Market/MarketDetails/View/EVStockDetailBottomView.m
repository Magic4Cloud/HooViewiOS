//
//  EVStockDetailBottomView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVStockDetailBottomView.h"
#import "EVLineView.h"
#import "EVTabbarItem.h"
#import "EVBottomButton.h"

@interface EVStockDetailBottomView ()<EVBottomButtonDelegate>


@property (nonatomic, weak) UIView *bottonView;

@property (nonatomic, weak) EVBottomButton *bottomBtn;
@end

@implementation EVStockDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
    }
    return self;
}

- (void)addUpViewFrame:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = [UIColor evLineColor];
    [self addSubview:lineView];
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2, 1,ScreenWidth/2 ,48)];
    bottonView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottonView];
    self.bottonView = bottonView;

    UIView *HLineView = [[UIView alloc] initWithFrame:CGRectMake(18, 15, 2, 18)];
    HLineView.backgroundColor = [UIColor evMainColor];
//    [self addSubview:HLineView];
    
    UIButton *commentButton = [[UIButton alloc] init];
    commentButton.frame = CGRectMake(12, 6, ScreenWidth/2 - 27, 36);
    [commentButton setTitle:@" 来一起讨论吧~            " forState:(UIControlStateNormal)];
    commentButton.titleLabel.font = [UIFont textFontB3];
    commentButton.layer.borderWidth = 1;
    commentButton.layer.borderColor = [UIColor evDDDColor].CGColor;
    commentButton.layer.cornerRadius = 8;
    [commentButton setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:(UIControlStateNormal)];
    [commentButton addTarget:self action:@selector(commontClick) forControlEvents:(UIControlEventTouchUpInside)];
    commentButton.tag = EVBottomButtonTypeComment;
    [self addSubview:commentButton];
    
    
}

- (void)addButtonTitleArray:(NSArray *)title seleteTitleArr:(NSArray *)seletetitle imageArray:(NSArray *)image seleteImage:(NSArray *)seleteimage
{
//    NSArray *titleArray = @[@"+自选",@"分享",@"刷新"];
//    NSArray *seleteTitleArr = @[@"已添加",@"分享 ",@"刷新 "];
//    NSArray *imageArray = @[@"hv_normal_add_stock",@"hv_share",@"hv_refresh"];
//    NSArray *seleteImageArr = @[@"hv_selected_add_stock",@"hv_share",@"hv_refresh"];
    for (NSInteger i = 0; i < 3; i++) {
        EVBottomButton *bottomButton =  [[EVBottomButton alloc] initWithSelectImage:[UIImage imageNamed:seleteimage[i]] nomalImg:[UIImage imageNamed:image[i]] selectTitle:seletetitle[i] nomalTitle:title[i]];
        [self.bottonView  addSubview:bottomButton];
        bottomButton.tag = 1000+i;
        bottomButton.delegate = self;
        bottomButton.frame = CGRectMake(i * ScreenWidth/6, 0, ScreenWidth/6, 48);
        if (i == 2) {
            bottomButton.hideCountL = YES;
            self.bottomBtn = bottomButton;
        }
    }
}

- (void)setCommentCount:(NSInteger)commentCount
{
//    EVLog(@"0000000000000000888888****  %ld",commentCount < 0 ? commentCount : 1000);
    self.bottomBtn.commentCount = commentCount;
}


- (void)buttonItem:(UIButton *)btn tag:(NSInteger)tag
{    
    EVBottomButtonType type = btn.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailBottomClick:button:)]) {
        [self.delegate detailBottomClick:type button:btn];
    }
}

- (void)setIsCollec:(BOOL)isCollec
{
    _isCollec = isCollec;
    EVBottomButton *btn =   [self.bottonView viewWithTag:1001];
    [btn updateIsCollec:isCollec bottomBtn:btn];
}

- (void)setIsMarketCollect:(BOOL)isMarketCollect
{
    _isMarketCollect = isMarketCollect;
    EVBottomButton *btn =   [self.bottonView viewWithTag:1000];
    [btn updateIsCollec:isMarketCollect bottomBtn:btn];
}

- (void)commontClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailBottomClick:button:)]) {
        [self.delegate detailBottomClick:EVBottomButtonTypeComment button:nil];
    }

}
@end
