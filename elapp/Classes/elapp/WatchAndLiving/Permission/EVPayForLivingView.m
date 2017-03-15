//
//  EVPayForLivingView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPayForLivingView.h"
#import <PureLayout/PureLayout.h>
#import "UIImageView+LBBlurredImage.h"

#define kPayLivePriceKey        @"price"

static CGFloat const topImageViewTopPadding    = 75.f;
static CGFloat const topImageViewSize          = 80.f;
static CGFloat const topTitleLabTopPadding     = 30.f;
static CGFloat const needLabTopPadding         = 20.f;
static CGFloat const payBtnBottomPadding       = 100.f;
static CGFloat const payBtnWidth               = 297.f;
static CGFloat const payBtnHeight              = 40.f;
static CGFloat const paddingBetweenBtn         = 15.f;
static CGFloat const rechargeBtnHeight         = 20.5f;
static CGFloat const remainingLabBottomPadding = 15.f;

@interface EVPayForLivingView ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel  *topTitleLabe;
@property (nonatomic, weak) UILabel  *needPayNumLab;
@property (nonatomic, weak) UILabel  *remainingLab;
@property (nonatomic, weak) UIButton *goToRechargeBtn;
@property (nonatomic, weak) UIButton *payBtn;
@property (nonatomic, weak) UIButton *closeBtn;

@end

@implementation EVPayForLivingView

#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildPayViewUI];
    }
    return self;
}

#pragma mark - make up
- (void)makeUpPayViewWithInfoDictionary:(NSDictionary *)retinfo {
    NSString *ecoin     = retinfo[@"coin"];
    NSString *price     = retinfo[kPayLivePriceKey];
    NSDictionary *owner = retinfo[@"owner"];
    
    if (owner) {
        WEAK(self);
        [self.avatarImageView cc_setImageWithURLString:owner[kLogourl] placeholderImage:[UIImage imageNamed:@"avatar"] complete:^(UIImage *image) {
            weakself.avatarImageView.image = image;
        }];
        [self.backgroundImageView cc_setImageWithURLString:owner[kLogourl] placeholderImage:[UIImage imageNamed:@"avatar"] complete:^(UIImage *image) {
            weakself.backgroundImageView.image = image;
            [weakself.backgroundImageView setImageToBlur:image blurRadius:-40.0f completionBlock:nil];
        }];
//        self.topTitleLabe.text = owner[@"nick"];
    }
    [self p_makeUpNeedLabelText:[NSString stringWithFormat:@"%@", price]];
    [self p_makeUpRemainingLabelText:ecoin];
}

- (void)updatePayViewEcion:(NSString *)ecion {
    [self p_makeUpRemainingLabelText:ecion];
}


#pragma mark - private method
- (void)p_makeUpNeedLabelText:(NSString *)numberString {
    NSString *suffixString = @" 火眼豆";
  
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", numberString, suffixString]];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(numberString.length, suffixString.length)];
    self.needPayNumLab.attributedText = attString;
}
- (void)p_makeUpRemainingLabelText:(NSString *)numberString {
    self.remainingLab.text = [NSString stringWithFormat:@"我的火眼豆余额：%ld",  [numberString integerValue]];
}


#pragma mark - actions 
- (void)payAction:(UIButton *)btn {
    if (self.tapPayBtn) {
        self.tapPayBtn();
    }
}
- (void)goToRechargeAction:(UIButton *)btn {
    if (self.tapRechargeBtn) {
        self.tapRechargeBtn();
    }
}
- (void)closeAction:(UIButton *)btn {
    if (self.tapCloseBtn) {
        self.tapCloseBtn();
    }
}


#pragma mark - build UI
- (void)buildPayViewUI {
    self.backgroundColor = [UIColor whiteColor];
    // 背景图
    [self.backgroundImageView autoPinEdgesToSuperviewEdges];
    
    // 20%黑色背景
    [self addBlackBlurView];
    
    // 关闭btn
    [self.closeBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [self.closeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.closeBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    // 头像
    [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:topImageViewTopPadding];
    [self.avatarImageView autoSetDimensionsToSize:CGSizeMake(topImageViewSize, topImageViewSize)];
    
    // 付费直播label
    [self.topTitleLabe autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:topTitleLabTopPadding];
    [self.topTitleLabe autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.topTitleLabe autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.topTitleLabe autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    // 所需火眼豆label
    [self.needPayNumLab autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.needPayNumLab autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.needPayNumLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.needPayNumLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topTitleLabe withOffset:needLabTopPadding];
    
    // 付费观看btn
    [self.payBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.payBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-payBtnBottomPadding];
    [self.payBtn autoSetDimensionsToSize:CGSizeMake(payBtnWidth, payBtnHeight)];
    
    // 我要充值btn
    [self.goToRechargeBtn autoSetDimensionsToSize:CGSizeMake(payBtnWidth, rechargeBtnHeight)];
    [self.goToRechargeBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.payBtn withOffset:-paddingBetweenBtn];
    [self.goToRechargeBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 剩余火眼豆
    [self.remainingLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.goToRechargeBtn withOffset:-remainingLabBottomPadding];
    [self.remainingLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.remainingLab autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.remainingLab autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

- (void)addBlackBlurView {
    UIView *blackView = [UIView new];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = .5f;
    [self addSubview:blackView];
    [blackView autoPinEdgesToSuperviewEdges];
}

#pragma mark - lazy load 💤
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode   = UIViewContentModeScaleAspectFill;
        bgImageView.clipsToBounds = YES;
        [self addSubview:bgImageView];
        _backgroundImageView = bgImageView;
    }
    return _backgroundImageView;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        UIImageView *avatarIV = [UIImageView new];
        avatarIV.layer.cornerRadius  = topImageViewSize/2.f;
        avatarIV.layer.masksToBounds = YES;
        [self addSubview:avatarIV];
        _avatarImageView = avatarIV;
    }
    return _avatarImageView;
}
- (UILabel *)topTitleLabe {
    if (!_topTitleLabe) {
        UILabel *topLab = [UILabel new];
        topLab.textColor     = [UIColor whiteColor];
        topLab.font          = [UIFont systemFontOfSize:17];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.text          = @"付费直播";
        [self addSubview:topLab];
        _topTitleLabe = topLab;
    }
    return _topTitleLabe;
}
- (UILabel *)needPayNumLab {
    if (!_needPayNumLab) {
        UILabel *needLab = [UILabel new];
        needLab.textColor     = [UIColor whiteColor];
        needLab.font          = [UIFont boldSystemFontOfSize:40];
        needLab.textAlignment = NSTextAlignmentCenter;
        needLab.text          = @"0火眼豆";
        [self addSubview:needLab];
        _needPayNumLab = needLab;
    }
    return _needPayNumLab;
}
- (UILabel *)remainingLab {
    if (!_remainingLab) {
        UILabel *remainingLab = [UILabel new];
        remainingLab.textColor     = [UIColor whiteColor];
        remainingLab.font          = [UIFont systemFontOfSize:14];
        remainingLab.textAlignment = NSTextAlignmentCenter;
        remainingLab.text          = @"我的易余额：0";
        [self addSubview:remainingLab];
        _remainingLab = remainingLab;
    }
    return _remainingLab;
}
- (UIButton *)goToRechargeBtn {
    if (!_goToRechargeBtn) {
        UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeBtn setTitle:@"我要充值" forState:UIControlStateNormal];
        [rechargeBtn setTitleColor:[UIColor colorWithHexString:@"fb6655"] forState:UIControlStateNormal];
        [rechargeBtn addTarget:self action:@selector(goToRechargeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rechargeBtn];
        _goToRechargeBtn = rechargeBtn;
    }
    return _goToRechargeBtn;
}
- (UIButton *)payBtn {
    if (!_payBtn) {
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setTitle:@"付费观看" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        payBtn.backgroundColor     = [UIColor colorWithHexString:@"fb6655"];
        payBtn.layer.cornerRadius  = payBtnHeight/2.f;
        payBtn.layer.masksToBounds = YES;
        [self addSubview:payBtn];
        _payBtn = payBtn;
    }
    return _payBtn;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setImage:[UIImage imageNamed:@"living_icon_close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        _closeBtn = cancelButton;
    }
    return _closeBtn;
}


@end
