//
//  EVPasswordController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVPasswordController.h"
#import "EVBaseLoginView.h"
#import "EVPasswordView.h"
#import "EVUserSettingViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "AppDelegate.h"
#import "EVSDKInitManager.h"
#import "EVBugly.h"
#import "EVEaseMob.h"

@interface EVPasswordController ()
@property (nonatomic, weak) EVPasswordView *passwordView;
@property (nonatomic, strong) EVBaseToolManager *engine;

@end

@implementation EVPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadXibView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)loadXibView
{
    EVBaseLoginView *baseLoginView = [[[NSBundle mainBundle] loadNibNamed:@"EVBaseLoginView" owner:nil options:nil] lastObject];
    [self.view addSubview:baseLoginView];
    baseLoginView.frame = CGRectMake(0, 0, ScreenWidth, 400);
    baseLoginView.closeClick = ^(id close){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    EVPasswordView *passwordView = [[[NSBundle mainBundle] loadNibNamed:@"EVPasswordView" owner:nil options:nil]lastObject];
    [self.view addSubview:passwordView];
    passwordView.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100);
    self.passwordView = passwordView;
    passwordView.nextClick = ^(UIButton *sender) {
        if (self.resetPWD == YES) {
            [self resetPwd];
        }else {
            [self newRegist];
        }

//         [self upLoadLogoSuccess];
    };
    
}


- (void)newRegist
{
    NSString *verfifyCode = [NSString stringWithFormat:@"%@",self.verifyCode];
    if (self.passwordView.pwdTextFiled.text.length < 6 || self.passwordView.pwdTextFiled.text.length > 20) {
        [EVProgressHUD showDetailsMessage:@"请填写6-20位字母、数字，不能包含空格和符号" forView:self.view];
        return;
    }
    __weak typeof(self) wself = self;
    [EVProgressHUD hideHUDForView:self.view];
    NSString *Phone = self.loginInfo.phone;
    NSString *password = self.passwordView.pwdTextFiled.text;
    
    [self.view endEditing:YES];
    NSString *infoToken = [NSString stringWithFormat:@"%@_%@",verfifyCode,Phone];
    // 校验验证码
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:verfifyCode start:^{
    } fail:^(NSError *error) {
        NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [EVProgressHUD showError:message toView:wself.view];
    } success:^{
        [EVProgressHUD hideHUDForView:wself.view];
        EVLoginInfo *info = [[EVLoginInfo alloc] init];
        info.token = infoToken;
        info.phone = [NSString stringWithFormat:@"%@",self.loginInfo.phone];
        info.authtype = @"phone";
        info.password = [NSString stringWithFormat:@"%@",password];
        [self newUserRegister:info];
//        EVUserSettingViewController *userSettingVC = [EVUserSettingViewController userSettingViewController];
//        userSettingVC.isReedit = NO;
//        userSettingVC.userInfo = info;
//        [self.navigationController pushViewController:userSettingVC animated:YES];
    }];
}

- (NSMutableDictionary *)userInfoDict:(EVLoginInfo *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userName = [NSString stringWithFormat:@"%@%@",@"火眼财经",[self.loginInfo.phone substringWithRange:NSMakeRange(7, 4)]];
    [dict setValue:userName forKey:@"nickname"];
    NSString *phone  = [NSString stringWithFormat:@"86_%@",info.phone];
    [dict setValue:info.authtype forKey:kAuthType];
    [dict setValue:phone forKey:kToken];
    [dict setValue:@"1990-05-19" forKey:kBirthday];
    [dict setValue:info.password forKey:kPassword];
    return dict;
}


- (void)newUserRegister:(EVLoginInfo *)info
{
    WEAK(self)
    [self.engine GETNewUserRegistMessageWithParams:[self userInfoDict:info] start:^{
        weakself.passwordView.nextButton.enabled = NO;
        [EVProgressHUD showMessage:kE_GlobalZH(@"logining_user_information") toView:weakself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:weakself.view];
         weakself.passwordView.nextButton.enabled = YES;
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_user_information")];
        [EVProgressHUD showError:errorStr toView:weakself.view];
    } success:^(EVLoginInfo *loginInfo) {
        loginInfo.registeredSuccess = YES;
        EVLog(@"denglu---------------123   %@",loginInfo.name);
        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
        [loginInfo synchronized];
        [EVProgressHUD hideHUDForView:weakself.view];
//        weakself.userInfo.sessionid = loginInfo.sessionid;
//        if ( wself.userInfo.selectImage )
//        {
//            [wself upLoadLogoImage];
//        }
//        else
//        {
         [weakself loginEMIMInfo:loginInfo];
         [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
         [weakself upLoadLogoSuccess];
//        }
    }];
}

- (void)loginEMIMInfo:(EVLoginInfo *)info
{
    [EVEaseMob  checkAndAutoReloginWithLoginInfo:info loginFail:^(EMError *error) {
        EVLog(@"error----------  %@",error);
    }];
}

- (void)upLoadLogoSuccess
{
   
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
         [self.navigationController popToRootViewControllerAnimated:YES];
    }];
//    self.passwordView.nextButton.enabled = YES;
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    // 直接进入的注册，root view controller 为 loginVC
//    [appDelegate setUpHomeController];
    
}
//验证码确认
- (void)resetPwd
{
    __weak typeof(self) wself = self;
    [EVProgressHUD hideHUDForView:self.view];
    NSString *Phone = self.loginInfo.phone;
    NSString *password = self.passwordView.pwdTextFiled.text;
    
    [self.view endEditing:YES];
    NSString *resetPassWordPhone = [NSString stringWithFormat:@"%@_%@",@"86",Phone];
    // 校验验证码
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:_verifyCode start:^{
    } fail:^(NSError *error) {
        NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [EVProgressHUD showError:message toView:wself.view];
    } success:^{
        [self.engine GETUserResetPassword:self.passwordView.pwdTextFiled.text phone:resetPassWordPhone start:^{
            [EVProgressHUD showMessage:kSetting_again toView:wself.view];
        } fail:^(NSError *error) {
            [EVProgressHUD hideHUDForView:wself.view];
            NSString *errorStr = [error errorInfoWithPlacehold:kFail_setting];
        } success:^(BOOL success) {
            [EVProgressHUD hideHUDForView:wself.view];
            
            [self.engine GETPhoneUserPhoneLoginWithAreaCode:@"86" Phone:Phone password:password phoneNumError:^(NSString *numError) {
                [EVProgressHUD showError:numError toView:self.view];
            }  start:^{
                [EVProgressHUD showMessage:kLogin_loading toView:wself.view];
            } fail:^(NSError *error) {
                [EVProgressHUD hideHUDForView:wself.view];
                NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
            } success:^(EVLoginInfo *loginInfo) {
                EVLog(@"denglu---------------   %@",loginInfo.name);
                [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
                [wself upLoadLogoSuccess];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [appDelegate setUpHomeController];
                [EVBaseToolManager notifyLoginViewDismiss];
                [EVProgressHUD hideHUDForView:wself.view];
                [EVBugly setUserId:loginInfo.name];
                loginInfo.phone = Phone;
                [loginInfo synchronized];
                [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
            }];
            
            
        }];
    }];
}

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}
- (EVBaseToolManager *)engine
{
    if (!_engine) {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
