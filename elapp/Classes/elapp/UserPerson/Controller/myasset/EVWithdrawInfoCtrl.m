//
//  EVWithdrawInfoCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVWithdrawInfoCtrl.h"
#import "ALView+PureLayout.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

typedef NS_ENUM(NSUInteger, EVWithdrawInfoCtrlBtnType)
{
    EVWithdrawInfoCtrlBtnType_back = 1000,
    EVWithdrawInfoCtrlBtnType_withdraw
};

@interface EVWithdrawInfoCtrl ()

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong) EVBaseToolManager *engine;

@end

@implementation EVWithdrawInfoCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCBackgroundColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self navBar];
    [self mainView];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) mainView
{
    NSString *amount = [NSString stringWithFormat:@"%.2f",floor([self.withdrawAmount floatValue] * (1 - self.weixinFee) * 100) / 100.0f];
    self.amount = amount;
    
    UILabel *label = [self createLabel:kE_GlobalZH(@"money_list") font:20.f textColor:@"#5d5854"];
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [self.view addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:75.f];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UILabel *amountLabel = [self createLabel:[NSString stringWithFormat:@"%@%@",amount,kE_GlobalZH(@"e_money")] font:29.f textColor:@"#5d5854"];
    amountLabel.font = [UIFont boldSystemFontOfSize:29.f];
    [self.view addSubview:amountLabel];
    [amountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:15.f];
    [amountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    UILabel *label3 = [self createLabel:kE_GlobalZH(@"one_day_arrive_money") font:12.f textColor:@"#8b847e"];
    [self.view addSubview:label3];
    [label3 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:amountLabel withOffset:55.f];
    
    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.layer.borderColor = [UIColor colorWithHexString:kGlobalGreenColor].CGColor;
    shadowBtn.layer.borderWidth = 1.f;
    shadowBtn.layer.cornerRadius = 20.f;
    [shadowBtn setTitle:kE_GlobalZH(@"put_forward") forState:UIControlStateNormal];
    [shadowBtn setTitleColor:[UIColor colorWithHexString:kGlobalGreenColor] forState:UIControlStateNormal];
    shadowBtn.tag = EVWithdrawInfoCtrlBtnType_withdraw;
    [shadowBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shadowBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:shadowBtn];
    [shadowBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label3 withOffset:10.f];
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

- (void) navBar
{
    self.title = kE_GlobalZH(@"put_forward_affirm");
    
}

- (void) buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case EVWithdrawInfoCtrlBtnType_back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case EVWithdrawInfoCtrlBtnType_withdraw:
        {
            [self cashout];
        }
            break;
            
        default:
            break;
    }
}

- (EVBaseToolManager *)engine {
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (void) cashout
{
    __weak typeof(self) wself = self;
    NSInteger rmb = [self.withdrawAmount floatValue] * 100;
//    [self.engine GETCashoutRmb:[NSString stringWithFormat:@"%zd", rmb]
//                      start:^{
//                          [CCProgressHUD showMessage:kE_GlobalZH(@"put_forward_please_wait") toView:wself.view];
//                      } fail:^(NSError *error) {
//                          [CCProgressHUD hideHUDForView:wself.view];
//                          [CCProgressHUD showError:kE_GlobalZH(@"put_forward_fail") toView:wself.view];
//                      } success:^(NSDictionary *imInfo) {
//                          [CCProgressHUD hideHUDForView:wself.view];
//                          EVWithdrawSuccessCtrl *ctrl = [[EVWithdrawSuccessCtrl alloc] init];
//                          ctrl.amount = [self.amount mutableCopy];
//                          [wself.navigationController pushViewController:ctrl animated:YES];
//                      } sessionExpire:^{
//                          [CCProgressHUD hideHUDForView:wself.view];
//                          
//                          [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"fail_account_again_login") comfirmTitle:kOK WithComfirm:^{
//                              CCRelogin(wself);
//                          }];
//                      }];
}

@end
