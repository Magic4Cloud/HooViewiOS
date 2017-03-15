//
//  EVSetLivingPaySumView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVSetLivingPaySumView.h"
#import <PureLayout/PureLayout.h>
#import "EVLimitHeaderView.h"
#import "EVLineView.h"

static CGFloat const contentHeight           = 55.f;
static CGFloat const contentTopPadding       = 10.f;
static CGFloat const sumLabHorizontalPadding = 15.f;
static CGFloat const sumLabWidth             = 30.f;
static CGFloat const textFieldRightPadding   = 12.f;

static BOOL isShow;     /**< 判断当前视图是否已经展现 */

@interface EVSetLivingPaySumView ()<EVLimitHeaderViewDelegate>

@property (nonatomic, copy) void(^completeBlock)(NSString *str, BOOL isCancel);
@property (nonatomic, weak) UIView  *contentView;
@property (nonatomic, weak) UIView  *navView;
@property (nonatomic, weak) UILabel *sumTitleLab;
@property (nonatomic, weak) UILabel *sumSuffixLab;
@property (nonatomic, weak) UILabel *bottomDescriptionLab;
@property (nonatomic, weak) UITextField *sumTextField;
@property (nonatomic, weak) EVLimitHeaderView *navContentView;
@property (nonatomic, assign) BOOL isShowed;

@end


@implementation EVSetLivingPaySumView

#pragma mark - public class method
+ (void)showSetLivingPaySumViewToSuperView:(UIView *)targetView complete:(void(^)(NSString *sum, BOOL isCancel))complete {
    if (isShow) {
        return;
    }
    isShow = YES;
    EVSetLivingPaySumView *paySumView = [[EVSetLivingPaySumView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    [targetView addSubview:paySumView];
    
    paySumView.completeBlock = complete;
    CGRect frame = paySumView.frame;
    frame.origin.y = 0.f;
    [UIView animateWithDuration:.3 animations:^{
        paySumView.frame = frame;
    }];
}


#pragma mark - init views 💧
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLivingPaySumViewUI];
    }
    return self;
}

#pragma mark delegate
- (void)limitHeaderViewDidClickButton:(EVLimitHeaderViewButtonType)type {
    [self actionOfCompleteWithType:type];
}

#pragma mark private method
- (void)actionOfCompleteWithType:(EVLimitHeaderViewButtonType)type {
    switch (type) {
        case EVLimitHeaderViewButtonCancel: {
            [self p_callBackWithCancel:YES];
            break;
        }
        case EVLimitHeaderViewButtonComfirm: {
            if (self.sumTextField.text.length <= 0 || self.sumTextField.text.integerValue == 0) {
                [EVProgressHUD showError:@"请先输入金额"];
            } else if (![self isPositiveNumber:self.sumTextField.text]) {
                [EVProgressHUD showError:@"输入金额格式错误"];
            } else if (self.sumTextField.text.length > 8) {
                [EVProgressHUD showError:@"输入金额过大"];
            } else {
                [self p_callBackWithCancel:NO];
            }
            break;
        }
    }
}

- (BOOL)isPositiveNumber:(NSString *)aString {
    BOOL result = NO;
    NSString *regEx = @"^([1-9][0-9]*){1,3}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    result = [pred evaluateWithObject:aString];
    return result;
}

- (void)p_callBackWithCancel:(BOOL)isCancel {
    [self endEditing:YES];
    if (self.completeBlock) {
        self.completeBlock(self.sumTextField.text, isCancel);
        isShow = NO;
    }
    [self dismissPaySumView];
}

- (void)dismissPaySumView {
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark - build UI
- (void)buildLivingPaySumViewUI {
    self.backgroundColor = [UIColor evBackgroundColor];
    
    [self.navView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.navView autoSetDimension:ALDimensionHeight toSize:64];
    
    [self.navContentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.navContentView autoSetDimension:ALDimensionHeight toSize:44];
    
    [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(contentTopPadding + 64, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.contentView autoSetDimension:ALDimensionHeight toSize:contentHeight];
    
    [self.sumTitleLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.sumTitleLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:sumLabHorizontalPadding];
    [self.sumTitleLab autoSetDimension:ALDimensionWidth toSize:sumLabWidth];
    
    [self.sumSuffixLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.sumSuffixLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sumLabHorizontalPadding];
    [self.sumSuffixLab autoSetDimension:ALDimensionWidth toSize:sumLabWidth];
    
    [self.sumTextField autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.sumTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.sumTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sumTitleLab];
    [self.sumTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.sumSuffixLab withOffset:-textFieldRightPadding];
    
    [self.bottomDescriptionLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:contentTopPadding];
    [self.bottomDescriptionLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:sumLabHorizontalPadding];
    [self.bottomDescriptionLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sumLabHorizontalPadding];
    
    [EVLineView addTopLineToView:self.contentView];
    [EVLineView addBottomLineToView:self.contentView];
}

#pragma mark - lazy load 💤
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
        [self addSubview:self.contentView];
    }
    return _contentView;
}
- (UILabel *)sumTitleLab {
    if (!_sumTitleLab) {
        UILabel *sumTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sumTitleLab.text = @"金额";
        sumTitleLab.textColor = [UIColor colorWithHexString:@"403b37"];
        sumTitleLab.font = [UIFont boldSystemFontOfSize:13];
        _sumTitleLab = sumTitleLab;
        [self.contentView addSubview:self.sumTitleLab];
    }
    return _sumTitleLab;
}
- (UILabel *)sumSuffixLab {
    if (!_sumSuffixLab) {
        UILabel *sumSuffixLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sumSuffixLab.text = @"火眼豆";
        sumSuffixLab.textColor = [UIColor colorWithHexString:@"403b37"];
        sumSuffixLab.font = [UIFont boldSystemFontOfSize:13];
        _sumSuffixLab = sumSuffixLab;
        [self.contentView addSubview:self.sumSuffixLab];
    }
    return _sumSuffixLab;
}
- (UILabel *)bottomDescriptionLab {
    if (!_bottomDescriptionLab) {
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectZero];
        bottomLab.text = @"本次直播收入将由火眼财经代扣个税后转为可提现金额";
        bottomLab.textColor = [UIColor colorWithHexString:@"403b37" alpha:.5];
        bottomLab.font = [UIFont systemFontOfSize:12];
        bottomLab.numberOfLines = 2;
        _bottomDescriptionLab = bottomLab;
        [self addSubview:self.bottomDescriptionLab];
    }
    return _bottomDescriptionLab;
}
- (UITextField *)sumTextField {
    if (!_sumTextField) {
        UITextField *sumTF = [[UITextField alloc] initWithFrame:CGRectZero];
        sumTF.placeholder   = @"填写数量";
        sumTF.textAlignment = NSTextAlignmentRight;
        sumTF.keyboardType  = UIKeyboardTypeNumberPad;
        [sumTF becomeFirstResponder];
        _sumTextField = sumTF;
        [self.contentView addSubview:self.sumTextField];
    }
    return _sumTextField;
}
- (UIView *)navView{
    if (!_navView) {
        UIView *navView = [UIView new];
        navView.backgroundColor = [UIColor whiteColor];
        _navView = navView;
        [self addSubview:self.navView];
    }
    return _navView;
}
- (EVLimitHeaderView *)navContentView {
    if (!_navContentView) {
        EVLimitHeaderView *navContentView = [EVLimitHeaderView limitHeaderView];
        [navContentView configTitle:@"设置付费金额"];
        navContentView.delegate = self;
        _navContentView = navContentView;
        [self.navView addSubview:self.navContentView];
    }
    return _navContentView;
}

@end
