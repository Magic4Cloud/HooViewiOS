//
//  EVWithdrawSuccessCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVWithdrawSuccessCtrl.h"
#import "ALView+PureLayout.h"
#import "EVAlertManager.h"

#define kMoneySuccessStr @"请于24小时内在微信领取提现红包，过期未领取将不予处理"

typedef NS_ENUM(NSUInteger, EVWithdrawSuccessCtrlBtnType)
{
    EVWithdrawSuccessCtrlBtnType_back = 1000,
    EVWithdrawSuccessCtrlBtnType_done
};

@interface EVWithdrawSuccessCtrl ()

@end

@implementation EVWithdrawSuccessCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[EVAlertManager shareInstance] performComfirmTitle:kMoneySuccessStr message:nil comfirmTitle:kOK WithComfirm:nil];
    [self navBar];
    [self mainView];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) navBar
{
    self.title = kE_GlobalZH(@"put_forwoard_success");
    
}

- (void) mainView
{

    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 10, ScreenWidth, 160);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *label = [self createLabel:kE_GlobalZH(@"reality_to_money") font:15.f textColor:@"#262626"];
    label.font = [UIFont boldSystemFontOfSize:15.f];
    [backView addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backView withOffset:40.f];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UILabel *amountLabel = [self createLabel:self.amount font:34.f textColor:@"#262626"];
    amountLabel.font = [UIFont boldSystemFontOfSize:34.f];
    [self.view addSubview:amountLabel];
    [amountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:30.f];
    [amountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UILabel *label1 = [self createLabel:kE_GlobalZH(@"put_forward_money_deposit_wechat_account") font:12.f textColor:@"#858585"];
    [self.view addSubview:label1];
    [label1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:amountLabel withOffset:75.f];
    
    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.backgroundColor = [UIColor evMainColor];
    shadowBtn.layer.cornerRadius = 6.f;
    [shadowBtn setTitle:kE_GlobalZH(@"carry_out") forState:UIControlStateNormal];
    [shadowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shadowBtn.tag = EVWithdrawSuccessCtrlBtnType_done;
    [shadowBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shadowBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:shadowBtn];
    [shadowBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label1 withOffset:10.f];
    [shadowBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shadowBtn autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 30.f];
    [shadowBtn autoSetDimension:ALDimensionHeight toSize:40.f];
}

- (UILabel *) createLabel:(NSString *) text font:(CGFloat)fontSize textColor:(NSString *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithHexString:textColor];
    return label;
}

- (void) buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case EVWithdrawSuccessCtrlBtnType_back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case EVWithdrawSuccessCtrlBtnType_done:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

@end
