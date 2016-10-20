//
//  EVPhoneRegistFirstController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPhoneRegistFirstController.h"
#import <PureLayout.h>
#import "EVBaseToolManager.h"
#import "EVAlertManager.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVTextViewController.h"
#import "EVSelectRegionViewController.h"
#import "EVRegionCodeModel.h"
#import "EVPhoneRegionView.h"
#import "NSString+Checking.h"
#import "NSString+Extension.h"
#import "AppDelegate.h"
#import "EVBugly.h"
#import "EVUserSettingViewController.h"
#import "EVSDKInitManager.h"

#define kMaxWaitTime 60
#define kMaxWaitTime 60
#define CC_ABSOLUTE_IMAGE_W         414.0
#define CC_ABSOLUTE_IMAGE_H         736.0
@interface EVPhoneRegistFirstController () <CCSelectRegionViewControllerDelegate,CCPhoneRegionViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) EVRegionCodeModel *currRegion;
@property (strong, nonatomic) EVBaseToolManager *engine;
@property (assign, nonatomic) NSInteger seconds;
@property (copy, nonatomic) NSString *currPhoneNum;
@property (copy, nonatomic) NSString *currVerifyCode;
@property (assign, nonatomic) NSInteger timeLength; /**< 走表的最大值 */
@property (copy, nonatomic) NSString *pwdStr;

@property (copy, nonatomic) NSString  *verifyCodePhone;

@end

@implementation EVPhoneRegistFirstController
{
    EVPhoneRegionView *regionPhone;
}
#pragma mark - ***********         Init💧         ***********
+ (instancetype)phoneRegistFirstController
{
    EVPhoneRegistFirstController *regist = [[EVPhoneRegistFirstController alloc] init];
    return regist;
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    self.timeLength = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    CCLog(@"%@ dealloc", [self class]);
    [CCNotificationCenter removeObserver:self];
    [_engine cancelAllOperation];
}
#pragma mark - ***********      Build UI 🎨       ***********
- (void)configView
{
    regionPhone = [[EVPhoneRegionView alloc] init];
    regionPhone.passwordTextField.delegate = self;
    regionPhone.delegate = self;
    if (self.resetPWD)
    {
        self.title = kForget_password;
        regionPhone.attributedLabel.hidden = YES;
       regionPhone.passwordTextField.placeholder = kSetting_new_password;
        [regionPhone.confirmButton setTitle:kOK forState:(UIControlStateNormal)];
    }
    else
    {
        self.title = kLogin_account;
        regionPhone.attributedLabel.hidden = NO;
        regionPhone.passwordTextField.placeholder = kSetting_password;
        [regionPhone.confirmButton setTitle:kENext forState:(UIControlStateNormal)];
    }
    [self.view addSubview:regionPhone];
    
    [regionPhone autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.10f];
    [regionPhone autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [regionPhone autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [regionPhone autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
}

- (void)setUpData
{
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
}


#pragma mark - judge phone

- (NSString *)judgePasswordAndVerfifyCode:(NSString *)verfifyCode
{
        NSString *error;
        if (regionPhone.phoneText.text.length <= 0) {
            error = kNot_length_phone;
        }else if ( !verfifyCode || verfifyCode.length == 0 ) {
            error = kNot_verify_num;
        }else if (regionPhone.passwordTextField.text.length == 0) {
            error = kNot_password;
        }else if (regionPhone.passwordTextField.text.length < 6 || regionPhone.passwordTextField.text.length > 20) {
            error = kFail_length_password;
        }else if (verfifyCode.length < 4){
            error = kFail_length_verify_num;
        }else if (![self.verifyCodePhone isEqualToString:regionPhone.phoneText.text]){
            error = kE_GlobalZH(@"verify_success_phone");
        }else {
            error = kE_GlobalZH(@"e_correct");
        }
        return error;
}


- (BOOL) getVerifyCode
{
    [self.view endEditing:YES];
    NSString *phone = regionPhone.phoneText.text;

        if ( self.resetPWD )
        {
            [self sendVerfiCodeToPhone:phone messageType:RESETPWD];
        }
        else
        {
            [self sendVerfiCodeToPhone:phone messageType:PHONE];
        }
        
        return YES;
}

- (void)modifyTime
{
    if ( self.timeLength <= 1 )
    {
        [CCNotificationCenter removeObserver:self];
        [regionPhone.getVerificationCode setTitle:kSend_verify_num forState:UIControlStateNormal];
        self.timeLength = 0;
        regionPhone.getVerificationCode.backgroundColor = [UIColor colorWithHexString:@"#FF8DA8"];
        [regionPhone.getVerificationCode setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        regionPhone.getVerificationCode.userInteractionEnabled = YES;
        return;
    }
    self.timeLength -= 1;
    [regionPhone.getVerificationCode setTitle:[NSString stringWithFormat:kSend_again, self.timeLength] forState:UIControlStateNormal];
    regionPhone.getVerificationCode.backgroundColor = [UIColor whiteColor];
    [regionPhone.getVerificationCode setTitleColor:[UIColor colorWithHexString:@"#FF8DA8"] forState:(UIControlStateNormal)];
    regionPhone.getVerificationCode.userInteractionEnabled = NO;
}

- (void)phoneRegionView:(EVPhoneRegionView *)RegionView clickButtonWithTag:(CCPhoneVerificationCodeBtnTag)tag
{
    switch (tag)
    {
        case CCInternationalCodeButton:
        {
            if (regionPhone.phoneText.text.length == 0) {
                [CCProgressHUD showError:kNot_pbone];
                break;
            }else if (![NSString isPureNumandCharacters:regionPhone.phoneText.text]){
                [CCProgressHUD showError:kNot_format_phone];
                break;
            }else if (![regionPhone.phoneText.text CC_isPhoneNumberNew]){
                [CCProgressHUD showError:kNot_length_phone];
                break;
            }
            [self getVerifyCode];
            if (self.timeLength != 0) {
                return;
            }
            self.timeLength = 60;
            // 开始走表
            [CCNotificationCenter addObserver:self selector:@selector(modifyTime) name:CCUpdateForecastTime object:nil];
            //获取验证码
        }
            break;
            
        case CCCancelbutton:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
           break;
            
        case CCRegionSelectRegionButton:
        {
            EVSelectRegionViewController *selectRegionVC = [[EVSelectRegionViewController alloc] init];
            selectRegionVC.delegate = self;
            [self.navigationController pushViewController:selectRegionVC animated:YES];
        }
          break;
            
        case CCServiceButton:
            [self gotoShowTermWithType:CCTermOfService];
            break;
            
        case CCPrivateButton:
            [self gotoShowTermWithType:CCPrivacyPolicy];
            break;
            
        case CCConfimButton:
            if (self.resetPWD ) {
                [self resetPwd];
                break;
            }else{
                [self newRegist];
                break;
            }
            break;
    }
}
#pragma mark - ***********      Networks 🌐       ***********
/** 请求验证码 */
- (void)sendVerfiCodeToPhone:(NSString *)phone messageType:(SMSTYPE)type
{

    __weak typeof(self) wself = self;
    
    self.verifyCodePhone = phone;
    //杨尚彬 修改  内容:修改汉字加手机号的判断加了提示框
    [self.engine GETSmssendWithAreaCode:self.currRegion.area_code Phone:phone type:type phoneNumError:^(NSString *numError) {
        [CCProgressHUD showError:numError toView:self.view];
    } start:^{
        [CCProgressHUD showMessage:kE_GlobalZH(@"sending_verify_num")  toView:wself.view];
    } fail:^(NSError *error) {
        //注册失败上报错误日志给后台
        NSString *message = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_verify_num")];
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showError:message toView:wself.view];
    } success:^(NSDictionary *info) {
        
        [CCProgressHUD hideHUDForView:wself.view];
        // 持久化验证码id，防止用户切出去后，id为空，验证会失败
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        NSString *str = [NSString stringWithFormat:@"%@",info[kSms_id]];
        if ( str != nil && ![str isEqualToString:@""] && ![str isEqualToString:@"<null>"])
        {
            [ud setObject:info[kSms_id] forKey:kSms_id];
        }else {
            [CCProgressHUD showError:@"获取失败"];
        }
//        if ( info[kSms_id] != nil )
//        {
//            [ud setObject:info[kSms_id] forKey:kSms_id];
//        }
    }];
}

//验证码确认
- (void)resetPwd
{
     NSString *verfifyCode = [NSString stringWithFormat:@"%@",regionPhone.verifyInputField.text];
    NSString *error = [self judgePasswordAndVerfifyCode:verfifyCode];
    
    if ([error isEqualToString:kE_GlobalZH(@"e_correct")]) {
    }else{
        [CCProgressHUD showError:error];
        return;
    }
    __weak typeof(self) wself = self;
    [CCProgressHUD hideHUDForView:self.view];
    NSString *Phone = regionPhone.phoneText.text;
    NSString *password = regionPhone.passwordTextField.text;

    [self.view endEditing:YES];
    NSString *resetPassWordPhone = [NSString stringWithFormat:@"%@_%@",self.currRegion.area_code,Phone];
    // 校验验证码
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:verfifyCode start:^{
    } fail:^(NSError *error) {
        NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [CCProgressHUD showError:message toView:wself.view];
    } success:^{
        [self.engine GETUserResetPassword:regionPhone.passwordTextField.text phone:resetPassWordPhone start:^{
            [CCProgressHUD showMessage:kSetting_again toView:wself.view];
        } fail:^(NSError *error) {
            [CCProgressHUD hideHUDForView:wself.view];
            NSString *errorStr = [error errorInfoWithPlacehold:kFail_setting];
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:errorStr comfirmTitle:kOK WithComfirm:nil];
        } success:^(BOOL success) {
            [CCProgressHUD hideHUDForView:wself.view];
            
            [self.engine GETPhoneUserPhoneLoginWithAreaCode:self.currRegion.area_code Phone:Phone password:password phoneNumError:^(NSString *numError) {
                [CCProgressHUD showError:numError toView:self.view];
            }  start:^{
                [CCProgressHUD showMessage:kLogin_loading toView:wself.view];
            } fail:^(NSError *error) {
                [CCProgressHUD hideHUDForView:wself.view];
                NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
                [[EVAlertManager shareInstance] performComfirmTitle:errorStr message:nil comfirmTitle:kOK WithComfirm:nil];
            } success:^(EVLoginInfo *loginInfo) {
                [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate setUpHomeController];
                [EVBaseToolManager notifyLoginViewDismiss];
                [CCProgressHUD hideHUDForView:wself.view];
                [EVBugly setUserId:loginInfo.name];
                loginInfo.phone = Phone;
                [loginInfo synchronized];
            }];
         
            
        }];
    }];
}


- (void)newRegist
{
    NSString *verfifyCode = [NSString stringWithFormat:@"%@",regionPhone.verifyInputField.text];
    
    NSString *error = [self judgePasswordAndVerfifyCode:verfifyCode];
    
    if ([error isEqualToString:kE_GlobalZH(@"e_correct")]) {
        
    }else{
        [CCProgressHUD showError:error];
        return;
    }
    __weak typeof(self) wself = self;
    [CCProgressHUD hideHUDForView:self.view];
    NSString *Phone = regionPhone.phoneText.text;
    NSString *password = regionPhone.passwordTextField.text;
    
    [self.view endEditing:YES];
    NSString *infoToken = [NSString stringWithFormat:@"%@_%@",self.currRegion.area_code,Phone];
    // 校验验证码
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:verfifyCode start:^{
    } fail:^(NSError *error) {
        NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [CCProgressHUD showError:message toView:wself.view];
    } success:^{
        [CCProgressHUD hideHUDForView:wself.view];
        EVLoginInfo *info = [[EVLoginInfo alloc] init];
        info.token = infoToken;
        info.phone = [NSString stringWithFormat:@"%@",Phone];
        info.authtype = @"phone";
        info.password = [NSString stringWithFormat:@"%@",password];
        EVUserSettingViewController *userSettingVC = [EVUserSettingViewController userSettingViewController];
        userSettingVC.isReedit = NO;
        userSettingVC.userInfo = info;
        [self.navigationController pushViewController:userSettingVC animated:YES];
    }];
}


#pragma mark - event response
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [regionPhone.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark - response method
- (void)gotoShowTermWithType:(CCTextVCType)type
{
    EVTextViewController *tvc = [[EVTextViewController alloc] init];
    tvc.type = type;
    [self.navigationController presentViewController:tvc
                                            animated:YES
                                          completion:nil];
}

#pragma mark - CCSelectRegionViewControllerDelegate
- (void)selectRegiton:(EVRegionCodeModel *)region
{
    regionPhone.contryAndCodelabel.text = [NSString stringWithFormat:@"%@ + %@",region.contry_name ,region.area_code];
    self.currRegion = region;
}

#pragma mark - setter and getter
- (void)setCurrRegion:(EVRegionCodeModel *)currRegion
{
    _currRegion = currRegion;
}

- (EVBaseToolManager *)engine {
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
