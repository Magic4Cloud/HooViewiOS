//
//  EVAccountPhoneBindViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAccountPhoneBindViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "NSString+Extension.h"
#import "PureLayout.h"
#import "EVSelectRegionViewController.h"
#import "EVRegionCodeModel.h"
#import "NSString+Checking.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

#define kGetVerifButtonWidth 1

#define kGetVerfyCodeSeconds 60
#define kPasswordMinLength 6

#define kGetVerifButtonTitle kE_GlobalZH(@"send_verify_num")

@interface EVAccountPhoneBindViewController () <UITextFieldDelegate, CCSelectRegionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneContainView;
@property (weak, nonatomic) IBOutlet UIView *regionContainer;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (weak, nonatomic) IBOutlet UIView *verifyCodeContainView;

@property (weak, nonatomic) IBOutlet UIView *passwordContainView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *clearPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearPwdBtn;


@property (weak, nonatomic) IBOutlet UIButton *getVerifButton;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger seconds;

@property (nonatomic,assign) BOOL comfirmClicked;

@property (nonatomic,assign) CGFloat currConstant;

@property (nonatomic, strong) EVBaseToolManager *accountEngine;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (nonatomic, strong) EVRegionCodeModel *currRegion;

/**
 *  获取验证码
 */
- (IBAction)getVerifyCode;

/**
 *  停止计时
 */
- (void)stopFireVerifyCodeTime;

/**
 *  开始计时
 */
- (void)updateVerifyCodeButton;

@end

@implementation EVAccountPhoneBindViewController

+ (instancetype)accountPhoneBindViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"EVAccountPhoneBindViewController" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"new"];
}

- (void)dealloc{
    [_accountEngine cancelAllOperation];
    _accountEngine = nil;
    [_timer invalidate];
    _timer = nil;
}

- (EVBaseToolManager *)accountEngine{
    if ( _accountEngine == nil ) {
        _accountEngine = [[EVBaseToolManager alloc] init];
    }
    return _accountEngine;
}

- (void)setCurrRegion:(EVRegionCodeModel *)currRegion
{
    _currRegion = currRegion;
    self.regionLabel.text = [NSString stringWithFormat:@"%@ +%@", _currRegion.contry_name, _currRegion.area_code];
    self.phoneNumTextField.placeholder = kE_GlobalZH(@"login_phone");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopFireVerifyCodeTime];
}

- (void)addNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setUpView
{
    [self addUnderLineToView:self.phoneContainView];
    [self addUnderLineToView:self.verifyCodeContainView];
    [self addUnderLineToView:self.passwordContainView];
    [self addUnderLineToView:self.regionContainer];
    
    self.getVerifButton.layer.cornerRadius = 15;
    self.getVerifButton.layer.borderWidth = kGlobalSeparatorHeight;
    self.getVerifButton.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    [self.getVerifButton setTitleColor:[UIColor evlightGrayTextColor] forState:UIControlStateNormal];
    
    self.comfirmButton.backgroundColor = [UIColor evMainColor];
    self.comfirmButton.layer.cornerRadius = 22;
    [self disableComfirmButtom];
    
    self.phoneNumTextField.delegate = self;
    self.verifyCodeTextField.delegate = self;
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTap)];
    [self.phoneContainView addGestureRecognizer:phoneTap];
    
    UITapGestureRecognizer *verifyCodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verifyCodeTap)];
    [self.verifyCodeContainView addGestureRecognizer:verifyCodeTap];
    
    // passwordContainView
    UITapGestureRecognizer *passwordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordTap)];
    [self.passwordContainView addGestureRecognizer:passwordTap];
    
    self.title = kE_GlobalZH(@"phone_num_binding");
    
    // UITextFieldTextDidChangeNotification
    [EVNotificationCenter addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
}

- (void)addUnderLineToView:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    [view addSubview:line];
    line.backgroundColor = [UIColor evGlobalSeparatorColor];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)textChanged
{
    NSString *phone = self.phoneNumTextField.text;
//    self.clearPhoneBtn.selected = [CCBaseTool checkPhoneNumByRegx:phone];
    self.clearPhoneBtn.selected = [phone CC_isPhoneNumberNew];
    self.clearPhoneBtn.hidden = !phone.length;
    
    NSString *password = self.passwordTextField.text;
    self.clearPwdBtn.selected = password.length >= 6;
    self.clearPwdBtn.hidden = !password.length;
}

- (void)passwordTap{
    [self.passwordTextField becomeFirstResponder];
}

- (void)phoneTap{
    [self.phoneNumTextField becomeFirstResponder];
}

- (void)verifyCodeTap{
    [self.verifyCodeTextField becomeFirstResponder];
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textChange{
    if ( self.phoneNumTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0 && !self.comfirmClicked) {
        [self enableComfirmButtom];
    } else {
        [self disableComfirmButtom];
    }
    if ( self.passwordContainView.hidden == NO && self.passwordTextField.text.length > 0 ) {
        [self enableComfirmButtom];
    } else if ( self.passwordContainView.hidden == NO && self.passwordTextField.text.length == 0 ) {
        [self disableComfirmButtom];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( self.phoneNumTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0 && !self.comfirmClicked) {
        [self enableComfirmButtom];
    } else {
        [self disableComfirmButtom];
    }
    
    return YES;
}

- (IBAction)clearPhone:(UIButton *)sender
{
    self.phoneNumTextField.text = @"";
}

- (IBAction)clearPwd:(UIButton *)sender
{
    self.passwordTextField.text = @"";
}

- (IBAction)regionCode:(UIButton *)sender
{
    EVSelectRegionViewController *selectRegionVC = [[EVSelectRegionViewController alloc] init];
    selectRegionVC.delegate = self;
    
    if ( self.navigationController ) {
        [self.navigationController pushViewController:selectRegionVC animated:YES];
    }
    else
    {
        [self presentViewController:selectRegionVC animated:YES completion:nil];
    }
}

- (void)selectRegiton:(EVRegionCodeModel *)region
{
    self.currRegion = region;
}

- (void)startFireVerifyCodeTime
{
   self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateVerifyCodeButton) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.seconds = kGetVerfyCodeSeconds;
    self.getVerifButton.userInteractionEnabled = NO;
    [self.getVerifButton layoutIfNeeded];
}

- (void)disableComfirmButtom
{
    self.comfirmButton.userInteractionEnabled = NO;
}

- (void)enableComfirmButtom
{
//    self.comfirmButton.alpha = 1.0;
    self.comfirmButton.userInteractionEnabled = YES;
}

- (void)stopFireVerifyCodeTime
{
    [self.timer invalidate];
    self.timer = nil;
    [self.getVerifButton setTitle:kGetVerifButtonTitle forState:UIControlStateNormal];
    self.getVerifButton.backgroundColor = [UIColor clearColor];
    self.getVerifButton.userInteractionEnabled = YES;
}

- (void)updateVerifyCodeButton
{
    if ( self.seconds == 0 ) {
        [self stopFireVerifyCodeTime];
        return;
    }
    NSString *title = [NSString stringWithFormat:kE_GlobalZH(@"second_again_gain"),(int)self.seconds];
    [self.getVerifButton setTitle:title forState:UIControlStateNormal];
    self.getVerifButton.backgroundColor = [UIColor colorWithHexString:@"#d7d7d7"];
    
    self.seconds--;
}

- (IBAction)comfirmButtonDidClicked
{
    [self.view endEditing:YES];
//    if ( ![CCBaseTool checkPhoneNumByRegx:self.phoneNumTextField.text] )
    if ( ![self.phoneNumTextField.text CC_isPhoneNumberNew] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"fail_phone_num") toView:self.view];
        [self stopFireVerifyCodeTime];
        return;
    }
    if ( [self.verifyCodeTextField.text isEqualToString:@""] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"verify_fail_please_enter_new") toView:self.view];
        [self stopFireVerifyCodeTime];
        return;
    }
    if ( self.passwordTextField.text.length < 6 )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"fail_password") toView:self.view];
        [self stopFireVerifyCodeTime];
        return;
    }

    NSString *verifyCode = self.verifyCodeTextField.text;
    [EVProgressHUD showMessage:kE_GlobalZH(@"now_verify") toView:self.view];
    [self disableComfirmButtom];
    __weak typeof(self) wself = self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sms_id = [ud objectForKey:kSms_id];
    [self.accountEngine getSmsverifyWithSmd_id:sms_id sms_code:verifyCode start:^{
        [EVProgressHUD hideHUDForView:wself.view];
    } fail:^(NSError *error) {
        [wself enableComfirmButtom];
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"verify_fail")] toView:wself.view];
        self.seconds = 0;
    } success:^{
        [EVProgressHUD hideHUDForView:wself.view];
        [wself accountBind];
    }];
}

- (IBAction)getVerifyCode
{
     NSString *phoneNum = self.phoneNumTextField.text;
    if ( phoneNum.length == 0 ) {
        [EVProgressHUD showMessageInAFlashWithMessage:kE_GlobalZH(@"phone_num_not_nil")];
        return;
    }
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    
//    if ( ![CCBaseTool checkPhoneNumByRegx:phoneNum] ) {
    if ( ![phoneNum CC_isPhoneNumberNew] ) {

        [EVProgressHUD showError:kE_GlobalZH(@"phone_num_format_fail") toView:self.view];
        return;
    }
    phoneNum = [NSString stringWithFormat:@"%@_%@",self.currRegion.area_code, phoneNum];
    [self.accountEngine GETSmssendWithAreaCode:nil Phone:phoneNum type:0 phoneNumError:^(NSString *numError) {
        
    }  start:^{
        [wself startFireVerifyCodeTime];
    } fail:^(NSError *error) {
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"verify_fail")] toView:wself.view];
        [wself stopFireVerifyCodeTime];
    } success:^(NSDictionary *info) {
        
        if ([info[kRegistered]  isEqual: @(1)])     // 手机号已被绑定
        {
            [EVProgressHUD showError:kE_GlobalZH(@"phone_num_binding_account") toView:wself.view];
            [wself stopFireVerifyCodeTime];
            return;
        }
        
        [EVProgressHUD showSuccess:kE_GlobalZH(@"verify_send_phone") toView:wself.view];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ( info[kSms_id] != nil )
        {
            [ud setObject:info[kSms_id] forKey:kSms_id];
        }
    }];
}

- (void)accountBind{
    NSString *password = self.passwordTextField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( self.passwordContainView.hidden == NO ) {
        if ( password.length == 0 ) {
            [EVProgressHUD showMessageInAFlashWithMessage:kE_GlobalZH(@"not_password")];
            return;
        } else if ( password.length < kPasswordMinLength  ) {
            [EVProgressHUD showMessageInAFlashWithMessage:kE_GlobalZH(@"password_lessthan_six_num_again_enter")];
            return;
        } else if ( self.passwordContainView.hidden == NO ) {
            [params setValue:[password md5String] forKey:@"password"];
        }
    }
    [params setValue:@"phone" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%@_%@",self.currRegion.area_code,self.phoneNumTextField.text] forKey:kToken];
    [params setValue:[self.passwordTextField.text md5String] forKey:kPassword];
    __weak typeof(self) weakself = self;
    
    [self.accountEngine GETUserBindWithParams:params start:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"now_binding_phone_num") toView:weakself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:weakself.view];
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"fail_binding")] toView:weakself.view];
    } success:^{
        [EVProgressHUD hideHUDForView:weakself.view];
        [EVProgressHUD showSuccess:kE_GlobalZH(@"binding_success")];
        [weakself.model setValue:[NSString stringWithFormat:@"86_%@",weakself.phoneNumTextField.text] forKey:@"token"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:weakself.view];
        EVRelogin(weakself);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)endPage{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
