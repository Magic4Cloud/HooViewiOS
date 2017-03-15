//
//  EVWithdrawNumCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVWithdrawNumCtrl.h"
#import "ALView+PureLayout.h"
#import "EVLoginInfo.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "EVWithdrawInfoCtrl.h"
#import "EVAlertManager.h"

typedef NS_ENUM(NSUInteger, EVWithdrawNumCtrlBtnType)
{
    EVWithdrawNumCtrlBtnType_back = 1000,
    EVWithdrawNumCtrlBtnType_next
};

@interface EVWithdrawNumCtrl ()


@property (nonatomic, weak) UITextField *withdrawNumText;

@end

@implementation EVWithdrawNumCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor evBackgroundColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
    self.title = kE_GlobalZH(@"put_forward");

}

- (void) mainView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [bgView autoSetDimension:ALDimensionHeight toSize:55.f];
    
    UILabel *label = [self createLabel:kE_GlobalZH(@"money_list") font:15.f textColor:@"#262626"];
    [bgView addSubview:label];
    [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [label autoSetDimension:ALDimensionWidth toSize:60.0f];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    UITextField *withdrawNumText = [[UITextField alloc] init];
    withdrawNumText.placeholder = [NSString stringWithFormat:@"%@%@%@",kE_GlobalZH(@"today_put_forward_money"),self.nowWithdrawAmount,kE_GlobalZH(@"e_money")];
    [withdrawNumText setValue:[UIColor colorWithHexString:@"#acacac"] forKeyPath:@"_placeholderLabel.textColor"];
    [withdrawNumText setValue:[UIFont systemFontOfSize:15.f] forKeyPath:@"_placeholderLabel.font"];
    withdrawNumText.textColor = [UIColor blackColor];
    withdrawNumText.backgroundColor = [UIColor whiteColor];
    withdrawNumText.keyboardType = UIKeyboardTypeNumberPad;
    withdrawNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:withdrawNumText];
    [withdrawNumText autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeft];
    [withdrawNumText autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:label withOffset:15.0f];
    self.withdrawNumText = withdrawNumText;

    UILabel *label1 = [self createLabel:kE_GlobalZH(@"binding_wechat_embody_red_pack_send_wechat_account") font:12.f textColor:@"#858585"];
    [self.view addSubview:label1];
    [label1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [label1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bgView withOffset:10.f];

    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.layer.borderColor = [UIColor evMainColor].CGColor;
    shadowBtn.layer.borderWidth = 1.f;
    shadowBtn.layer.cornerRadius = 6.f;
    [shadowBtn setTitle:kE_GlobalZH(@"next") forState:UIControlStateNormal];
    [shadowBtn setBackgroundColor:[UIColor evMainColor]];
    [shadowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shadowBtn.tag = EVWithdrawNumCtrlBtnType_next;
    [shadowBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shadowBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:shadowBtn];
    [shadowBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label1 withOffset:55.f];
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
        case EVWithdrawNumCtrlBtnType_back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case EVWithdrawNumCtrlBtnType_next:
        {
            if (!self.withdrawNumText.text || [self.withdrawNumText.text isEqualToString:@""]) {
                [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"enter_put_forward_money") comfirmTitle:kOK WithComfirm:nil];
            }
            else if ([self.withdrawNumText.text floatValue] > [self.nowWithdrawAmount floatValue])
            {
                NSString *msg = [NSString stringWithFormat:@"%@%@%@",kE_GlobalZH(@"enter_put_forward_not_than"),self.nowWithdrawAmount,kE_GlobalZH(@"e_money")];
                [[EVAlertManager shareInstance] performComfirmTitle:nil message:msg comfirmTitle:kOK WithComfirm:nil];
                return;
            }
            else if ([self.withdrawNumText.text floatValue] < 2.f)
            {
                [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"enter_put_forward_not_two_money") comfirmTitle:kOK WithComfirm:nil];
            }
            else if ([self.withdrawNumText.text floatValue] > 0.f){
                if (![self isBindingWeixin]) {
                    EVWithdrawInfoCtrl *ctrl = [[EVWithdrawInfoCtrl alloc] init];
//                    ctrl.withdrawAmount = self.withdrawNumText.text;
//                    ctrl.weixinFee = self.weixinFee;
                    [self.navigationController pushViewController:ctrl animated:YES];
                } else {
                    EVWithdrawInfoCtrl *ctrl = [EVWithdrawInfoCtrl new];
                    ctrl.withdrawAmount = self.withdrawNumText.text;
                    ctrl.weixinFee = self.weixinFee;
                    [self.navigationController pushViewController:ctrl animated:YES];
                }
            } else {
                [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"enter_put_forward_money") comfirmTitle:kOK WithComfirm:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL) isBindingWeixin
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    for (EVRelationWith3rdAccoutModel *authModel in loginInfo.auth) {
        if ([authModel.type isEqualToString:@"weixin"]) {
            return YES;
        }
    }
    
    return NO;
}

@end
