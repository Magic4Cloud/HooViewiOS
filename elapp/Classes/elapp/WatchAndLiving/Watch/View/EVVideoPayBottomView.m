//
//  EVVideoPayBottomView.m
//  elapp
//
//  Created by 唐超 on 4/25/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVVideoPayBottomView.h"
#import "EVUserAsset.h"

@interface EVVideoPayBottomView ()
@property (weak, nonatomic) IBOutlet UIView *backCoverView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;

@end

@implementation EVVideoPayBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}


-(void)setup
{
    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(@"view", view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:bindings]];
    self.bounds = view.bounds;
    
    _viewchargeButton.layer.cornerRadius = 20;
    _viewchargeButton.layer.masksToBounds = YES;
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPayView)];
    [_backCoverView addGestureRecognizer:tap];
    

    [self setNeedsLayout];
}

- (void)showPayViewWithPayFee:(NSInteger )fee userAssetModel:(EVUserAsset *)assetModel
{
    
    _payFee = fee;
    _assetModel = assetModel;
    if (fee>assetModel.ecoin) {
        //余额不足
        [_viewchargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _viewBeansShortLabel.hidden = NO;
    }
    else
    {
        //余额充足
        [_viewchargeButton setTitle:@"购买" forState:UIControlStateNormal];
        _viewBeansShortLabel.hidden = YES;

    }
    
    _backCoverView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
        _backCoverView.alpha = 0.5;
        _backBottomContraint.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissPayView
{
    [UIView animateWithDuration:0.5 animations:^{
        _backCoverView.alpha = 0;
        _backBottomContraint.constant = - 345;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (IBAction)chargeOrPayButtonClick:(id)sender {
    if (self.payOrChargeButtonClick) {
        self.payOrChargeButtonClick(self);
    }
}

@end
