//
//  EVPwdResetViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPwdResetViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVAlertManager.h"
#import "EVPhoneLoginViewController.h"

typedef NS_ENUM(NSInteger, EVPhonePWDVCButtonType) {
    EVPhonePWDVCCancelButton = 100,
    EVPhonePWDVCClearPhoneTextField,
    EVPhonePWDVCGetVerifyCode,
    EVPhonePWDVCComfirm
};

@interface EVPwdResetViewController ()

@property (weak, nonatomic) IBOutlet UIView *pwdContainerView;
@property (weak, nonatomic) IBOutlet UIButton *pwdCancelButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *pwdRepetContainerView;
@property (weak, nonatomic) IBOutlet UIButton *pwdRepetCancelButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdRepetTextField;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic,strong) EVBaseToolManager *engine;

@end

@implementation EVPwdResetViewController

#pragma mark - life cycle
+ (instancetype)pwdResetViewController
{
    return [UIStoryboard storyboardWithName:@"EVPwdResetViewController" bundle:nil].instantiateInitialViewController;
}

- (void)dealloc
{
    CCLog(@"%@ dealloc", [self class]);
    [CCNotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    [self setUpNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setUpNotification {
    [CCNotificationCenter addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)configView
{
    self.cancelButton.tag = EVPhonePWDVCCancelButton;
    self.pwdCancelButton.tag = EVPhonePWDVCClearPhoneTextField;
    self.pwdRepetCancelButton.tag = EVPhonePWDVCGetVerifyCode;
    self.comfirmButton.tag = EVPhonePWDVCComfirm;
    
    self.comfirmButton.layer.cornerRadius = 0.5 * self.comfirmButton.bounds.size.height;
    self.comfirmButton.backgroundColor = CCAppMainColor;
    
    [self.cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pwdCancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pwdRepetCancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.comfirmButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pwdRepetCancelButton.hidden = YES;
    self.pwdCancelButton.hidden = YES;
}

#pragma mark - event response
- (void)textChange
{
    NSString *pwd = self.pwdTextField.text;
    NSString *pwdRept = self.pwdRepetTextField.text;
    
    self.pwdRepetCancelButton.hidden = pwdRept.length == 0;
    self.pwdCancelButton.hidden = pwd.length == 0;
    
    self.pwdRepetCancelButton.selected = pwdRept.length >= 6;
    self.pwdCancelButton.selected = pwd.length >= 6;
}

- (void)buttonDidClicked:(UIButton *)btn
{
    switch ( btn.tag )
    {
        case EVPhonePWDVCCancelButton:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case EVPhonePWDVCClearPhoneTextField:
            self.pwdTextField.text = @"";
            [self textChange];
            break;
        case EVPhonePWDVCGetVerifyCode:
            self.pwdRepetTextField.text = @"";
            [self textChange];
            break;
        case EVPhonePWDVCComfirm:
            [self comfirm];
            break;
        default:
            break;
    }
}

- (void)comfirm
{
    NSString *password = self.pwdTextField.text;
    NSString *passwordrepy = self.pwdRepetTextField.text;
    
    if ( password.length < 6 )
    {
        [CCProgressHUD showError:kPassword_lessthan_six_num toView:self.view];
        return;
    }
    
    if ( passwordrepy.length < 6 )
    {
        [CCProgressHUD showError:kPassword_lessthan_six_num toView:self.view];
        return;
    }
    
    if ( ![password isEqualToString:passwordrepy] )
    {
        [CCProgressHUD showError:kEnter_two_same toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    [CCProgressHUD hideHUDForView:self.view];
    [self.engine GETUserResetPassword:password phone:self.phone start:^{
        [CCProgressHUD showMessage:kSend_again toView:wself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        NSString *errorStr = [error errorInfoWithPlacehold:kFail_setting];
        [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:errorStr comfirmTitle:kOK WithComfirm:nil];
    } success:^(BOOL success) {
        [CCProgressHUD hideHUDForView:wself.view];
        [self gotoLoginVC];
    }];
}

- (void)gotoLoginVC
{
    EVPhoneLoginViewController *phoneLoginVC = self.navigationController.viewControllers[1];
    phoneLoginVC.phone = self.phone;
    [self.navigationController popToViewController:phoneLoginVC animated:YES];
}

- (void)addUnderLineToView:(UIView *)view
{
    UIView *line = [[UIView alloc] init];
    [view addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

#pragma mark - setter and getter

- (EVBaseToolManager *)engine
{
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
