//
//  EVTabbarItem.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/16.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVTabbarItem.h"
#import <PureLayout.h>

static CGFloat const kTitleBottom = 7.f;
static CGFloat const kTitleTop = -1.f;
static CGFloat const kImgWidth = 30.f;
static CGFloat const kImgHeight = 30.f;
static CGFloat const kRedPointSize = 14.f;

@interface EVTabbarItem ()
@property (nonatomic) UIView *content;
@property (nonatomic) UIImageView * redPoint;
@property (nonatomic) UIButton *touchBtn;
@property (nonatomic) UIImageView *tabImg;
@property (nonatomic) UILabel *tabTitle;
@property (nonatomic) UIImage *selectImg;
@property (nonatomic) UIImage *normalImg;
@end


@implementation EVTabbarItem
- (instancetype)initWithSelectImg:(UIImage *)selectImg normalImg:(UIImage *)normalImg title:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.selectImg = selectImg;
        self.normalImg = normalImg;
        self.tabImg.image = normalImg;
        self.tabTitle.text = [NSString stringWithFormat:@"%@", title];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.clipsToBounds = YES;
    
    [self addSubview:self.content];
    [self.content addSubview:self.tabTitle];
    [self.content addSubview:self.tabImg];
    [self.content addSubview:self.redPoint];
    [self.content addSubview:self.touchBtn];
    
    [self.content autoPinEdgesToSuperviewEdges];
    
    [self.tabTitle autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTitleBottom];
    [self.tabTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.tabImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tabTitle withOffset:-kTitleTop];
    [self.tabImg autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.tabImg autoSetDimensionsToSize:CGSizeMake(kImgWidth, kImgHeight)];
    
    [self.redPoint autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tabImg withOffset:-3];
    [self.redPoint autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.tabImg withOffset:5];
    [self.redPoint autoSetDimensionsToSize:CGSizeMake(kRedPointSize, kRedPointSize)];
    
    [self.touchBtn autoPinEdgesToSuperviewEdges];
}
#pragma mark - public method
- (void)selectItem:(BOOL)YorN {
    self.touchBtn.selected = YorN;
    if (YorN) {
        [self setSelectStatus];
    } else {
        [self setNormalStatus];
    }
}
- (void)showRedPoint:(BOOL)YorN {
    self.redPoint.hidden = !YorN;
}

- (void)touchUpInside:(UIButton *)btn
{
    self.tabTitle.alpha = 1;
    self.tabImg.alpha = 1;
    if ([self.delegate respondsToSelector:@selector(didClickedTabbarItem:)]) {
            [self.delegate didClickedTabbarItem:self];
    }
}

- (void)touchDown:(UIButton *)btn
{
    self.tabTitle.alpha = 0.5;
    self.tabImg.alpha = 0.5;
}

- (void)touchCancel:(UIButton *)btn
{
    self.tabTitle.alpha = 1;
    self.tabImg.alpha = 1;
}
#pragma mark - private method
- (void)setNormalStatus {
    self.tabTitle.textColor = [UIColor evTextColorH2];
    self.tabImg.image = self.normalImg;
}
- (void)setSelectStatus {
    self.tabTitle.textColor = [UIColor evMainColor];
    self.tabImg.image = self.selectImg;
}

#pragma mark - getter 💤
- (UIView *)content {
    if (!_content) {
        _content = [UIView new];
    }
    return _content;
}
- (UIImageView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_n"]];
        _redPoint.hidden = YES;
//        _redPoint.backgroundColor = [UIColor evMainColor];
//        _redPoint.layer.cornerRadius = .5 * kRedPointSize;
//        _redPoint.clipsToBounds = YES;
    }
    return _redPoint;
}
- (UIButton *)touchBtn {
    if (!_touchBtn) {
        _touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
        [_touchBtn addTarget:self action:@selector(touchDown:) forControlEvents:(UIControlEventTouchDown)];
        [_touchBtn addTarget:self action:@selector(touchCancel:) forControlEvents:(UIControlEventTouchCancel|UIControlEventTouchDragExit)];
    }
    return _touchBtn;
}

- (UIImageView *)tabImg {
    if (!_tabImg) {
        _tabImg = [UIImageView new];
    }
    return _tabImg;
}
- (UILabel *)tabTitle {
    if (!_tabTitle) {
        _tabTitle = [UILabel new];
        _tabTitle.font = [UIFont systemFontOfSize:10];
        _tabTitle.textColor = [UIColor evTextColorH2];
    }
    return _tabTitle;
}


@end
