//
//  EVLoginViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoginViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVUserSettingViewController.h"
#import "EVPhoneRegistFirstController.h"
#import "AppDelegate.h"
#import "EVAlertManager.h"
#import "PureLayout.h"
#import "EVNavigationController.h"
#import "EVLoginView.h"
#import "EVPhoneLoginViewController.h"
#import "EVBugly.h"
#import "EV3rdPartAPIManager.h"
#import "EVTextViewController.h"
#import "EVSDKInitManager.h"
#import "EVHVLoginView.h"
#import "EVProgressHUD.h"
#import "EVRegionCodeModel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "NSString+Extension.h"
#import "EVShareManager.h"
#import "EVEaseMob.h"



#define kGettingThirdPartUserInfo   kE_GlobalZH(@"obtain_user_three_info")
#define kSynThirdPartUserInfo       kE_GlobalZH(@"sunch_user_three_info")

#define kNotificationDefaultName @"default"
#define kFirstLoginKey              @"firstloginkey"
#define kFirstLoginValue            @"firstloginvalue"

typedef NS_ENUM(NSInteger, CCLoginViewButtonType) {
    CCLoginViewRegistButton = 300,
    CCLoginViewLoginButton,
    CCLoginViewQQButton,
    CCLoginViewWeixinButton,
    CCLoginViewSinaButton
};

@interface EVLoginViewController () <UIScrollViewDelegate,CCLogWindowDelegate,EVHVLoginViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) EVBaseToolManager   *engine;
@property (nonatomic, strong) UIScrollView *navSV;
@property (nonatomic, strong) UIButton     *removeNavSVBtn;


@property (nonatomic, weak) EVHVLoginView *loginView;
@property (nonatomic, strong) EVRegionCodeModel *currRegion;

@end

@implementation EVLoginViewController 

#pragma mark - life cycle

+ (UINavigationController *)loginViewControllerWithNavigationController
{
    EVLoginViewController *con = [[EVLoginViewController alloc] init];
    con.definesPresentationContext = YES; //self is presenting view controller
    con.modalPresentationStyle = UIModalPresentationFullScreen;
    con.view.backgroundColor = [UIColor whiteColor];
    return [[EVNavigationController alloc]initWithRootViewController:con];;
}

- (instancetype)init
{
    if ( self = [super init] )
    {
        [EVAppSetting shareInstance].isLogining = YES;
        
    }
    return self;
}

- (void)dealloc
{
    EVLog(@"%@ dealloc", [self class]);
    [EVAppSetting shareInstance].isLogining = NO;
    [_engine cancelAllOperation];
    _engine = nil;
    [EVNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    
    [self addUpView];
    [self logoutIm];
    [self conFigView];
    [self setUpNotification];
    [self addThirdPartConfigForLoginVC];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)addUpView
{
    
    NSArray *loginXib = [[NSBundle mainBundle] loadNibNamed:@"EVHVLoginView" owner:nil options:nil];
    EVHVLoginView *baseLoginView = [loginXib firstObject];
    [self.view addSubview:baseLoginView];
    baseLoginView.frame = [UIScreen mainScreen].bounds;
    self.loginView = baseLoginView;
    baseLoginView.delegate = self;
    baseLoginView.PhoneTextFiled.delegate = self;
    baseLoginView.passwordTextFiled.delegate = self;
    if (![EVShareManager qqInstall] ) {
        self.loginView.qqLogin.hidden = YES;
    }
    if (![EVShareManager weiBoInstall]) {
        self.loginView.weiBoLogin.hidden = YES;
    }
    
    if (![EVShareManager weixinInstall]) {
        self.loginView.weChatLogin.hidden = YES;
    }
}

- (void)loginViewButtonType:(EVLoginClickType)type button:(UIButton *)button
{
    switch (type) {
        case EVLoginClickTypeClose:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case EVLoginClickTypeNext:
            [self phoneLogin];
            break;
        case EVLoginClickTypeProtocol:
        {
            EVPhoneRegistFirstController *phoneRegisrVC = [[EVPhoneRegistFirstController alloc] init];
            phoneRegisrVC.resetPWD = YES;
            [self.navigationController pushViewController:phoneRegisrVC animated:YES];
            
        }
            break;
        case EVLoginClickTypeQQ:
            [[EV3rdPartAPIManager sharedManager] qqLogin];
            button.selected = !button.selected;
            
            break;
        case EVLoginClickTypeWeiBo:
            [[EV3rdPartAPIManager sharedManager] weiboLogin];
            button.selected = !button.selected;
            
            break;
        case EVLoginClickTypeWeChat:
            [[EV3rdPartAPIManager sharedManager] weixinLoginWithViewController:self];
            button.selected = !button.selected;
            break;
        case EVLoginClickTypeHidePwd:
           
            break;
        default:
            break;
    }
}

#pragma -- delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self autoSpace:textField andRang:range andString:string];
}

- (BOOL)autoSpace:(UITextField *)textField andRang:(NSRange)range andString:(NSString *)string {
    
    if (textField == self.loginView.PhoneTextFiled) {
        NSInteger row = textField.text.length - 1;
        // 退格（删除）
        if (range.length == 1 && range.location == textField.text.length - 1) {
            if ((row % 7 == 1 && row > 1) || (row % 7 == 3 && row/8 == 0)) {
                
                textField.text = [textField.text substringToIndex:row];
            }
        }else {
            // 只能输入数字、字母
            NSString *regex = @"[a-z0-9A-Z]+";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![pred evaluateWithObject:string] || textField.text.length >= 13) {
                
                return NO;
            }
            if ((row % 6 == 1 && row != 0) || (row % 6 == 0 && row != 0)) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
                });
            }
            
        }
        
        return YES;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self phoneLogin];
    return YES;
    
}

#pragma mark - 手机登录
- (void)phoneLogin
{
    [self.loginView.PhoneTextFiled resignFirstResponder];
    NSString *phone = self.loginView.PhoneTextFiled.text;
    NSString *pwd =  self.loginView.passwordTextFiled.text;
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length < 11) {
        [EVProgressHUD showError:@"请输入11位手机号"];
        return;
    }else if (pwd.length < 6 || pwd.length > 20) {
        [EVProgressHUD showDetailsMessage:@"请填写6-20位字母、数字，不能包含空格和符号" forView:self.view];
        return;
    }
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    [self.engine GETPhoneUserPhoneLoginWithAreaCode:@"86" Phone:phone password:pwd phoneNumError:^(NSString *numError) {
        [EVProgressHUD showError:numError toView:self.view];
    }  start:^{
        [EVProgressHUD showMessage:kLogin_loading toView:wself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        if (error.code == -1003 || error.code == -1009) {
            [EVProgressHUD showMessage:@"您的网络异常请稍后再试"];
            return;
        }
        NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
        [EVProgressHUD showMessage:errorStr];
//        [[EVAlertManager shareInstance] performComfirmTitle:errorStr message:nil comfirmTitle:kOK WithComfirm:nil];
    } success:^(EVLoginInfo *loginInfo) {
        [EVProgressHUD hideHUDForView:wself.view];
        [wself dismissViewControllerAnimated:YES completion:nil];
        [EVBugly setUserId:loginInfo.name];
        EVLog(@"denglu---------------   %@",loginInfo.name);
        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
        loginInfo.phone = wself.loginView.PhoneTextFiled.text;
        [loginInfo synchronized];
        [wself gotoHomePage];
        [wself loginEMIMInfo:loginInfo];
        [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
    }];
}

- (void)loginEMIMInfo:(EVLoginInfo *)info
{
    [EVEaseMob  checkAndAutoReloginWithLoginInfo:info loginFail:^(EMError *error) {
        EVLog(@"error----------  %@",error);
    }];
}


- (void)buttonPush
{
//    EVTestViewController *phoneVC = [[EVTestViewController alloc] init];
//    [self.navigationController pushViewController:phoneVC animated:YES]; 
}
/**
 * ---注销环信
 */
- (void)logoutIm
{
    [EVBaseToolManager imLogoutUnbind:NO success:^(NSDictionary *info) {
        [EVBaseToolManager setIMAccountHasLogin:NO];
     
//        [[EVEaseMob cc_shareInstance] clear];

    } fail:^(EMError *error) {
        
    }];
}

- (void)conFigView
{
//    EVLoginView *loginView = [[EVLoginView alloc] init];
//    loginView.delegate = self;
//    [self.view addSubview:loginView];
//    [loginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    // 首次使用app，启动引导页
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ( [ud objectForKey:kFirstLoginKey] == nil )
    {
        [self.view addSubview:self.navSV];
        [self.removeNavSVBtn addTarget:self
                                action:@selector(removeNavSVBtnClick:)
                      forControlEvents:UIControlEventTouchUpInside];
        [ud setObject:kFirstLoginValue forKey:kFirstLoginKey];
    }
}

- (void)removeNavSVBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:1.0 animations:^{
        self.navSV.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navSV removeFromSuperview];
        self.navSV = nil;
    }];
}

- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(enterForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];

    [EVNotificationCenter addObserver:self selector:@selector(phoneLoginSuccess) name:CCLoginViewControllerNeedToDismissNotification object:nil];
}


- (void)addThirdPartConfigForLoginVC {
    WEAK(self);
    [[EV3rdPartAPIManager sharedManager] setQqLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself qqLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setQqLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself weixinLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself sinaLoginSuccess:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setSinaLoginFailure:^(NSDictionary *callBackDic) {
        [weakself loginFailed:callBackDic];
    }];
}

- (void)phoneLoginSuccess
{
    if ( self.autoDismiss )
    {
        [self gotoHomePage];
    }
}

- (EVBaseToolManager *)engine
{
    if ( !_engine )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

- (UIButton *)removeNavSVBtn
{
    if ( !_removeNavSVBtn )
    {
        _removeNavSVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _removeNavSVBtn;
}

- (void)enterForeGround
{
    [EVProgressHUD hideHUDForView:self.view];
}

-(void)loginView:(EVLoginView *)loginView clickButtonWithTag:(EVLoginViewButtonTag)tag
{
    switch (tag)
    {
        case EVRegistButton:
        {
            EVPhoneRegistFirstController *registerVC = [EVPhoneRegistFirstController phoneRegistFirstController];
            [self.navigationController pushViewController:registerVC animated:YES];
        }                
            break;
            
        case EVLoginButton:
        {
            EVPhoneLoginViewController *loginVC = [EVPhoneLoginViewController phoneLoginViewController];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
            break;
            
        case EVQQbtn:
            [[EV3rdPartAPIManager sharedManager] qqLogin];
            break;
            
        case EVWeixinbtn:
            [[EV3rdPartAPIManager sharedManager] weixinLoginWithViewController:self];
            
            break;
            
        case EVWeibobtn:
            [[EV3rdPartAPIManager sharedManager] weiboLogin];
            break;
        default:
            break;
    }
}

#pragma mark - 第三方登录
- (void)qqLoginSuccess:(NSDictionary *)userInfo {
    NSString *accessToken = userInfo[@"accessToken"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *openId = userInfo[@"openId"];
    if ( accessToken.length == 0 || expires_in.length == 0 || openId.length == 0 )
    {
       
       [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoQQ;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.openID = openId;
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^{
        [EVProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    }success:^(EVThirdPartUserInfo *userInfo) {
        [wself thirdPartUserLoginWith:userInfo];
        [EVProgressHUD hideHUDForView:wself.view];
    } fail:^(NSError *error) {
        //QQ登录失败要上传的错误
        [EVProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];;
        return;
    }];
}

- (void)sinaLoginSuccess:(NSDictionary *)userInfo
{
    NSString *accessToken = userInfo[@"access_token"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *refresh_token = userInfo[@"refresh_token"];
    NSString *uid = [NSString stringWithFormat:@"%@",userInfo[@"uid"]];
    
    if ( accessToken.length == 0 || expires_in.length == 0 || refresh_token.length == 0 || uid.length == 0 )
    {
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoSina;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.refresh_token = refresh_token;
    userModel.uid = uid;
    
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^{
        [EVProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } success:^(EVThirdPartUserInfo *userInfo) {
        [EVProgressHUD hideHUDForView:wself.view];
        [wself thirdPartUserLoginWith:userInfo];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];;
    }];
}

- (void)weixinLoginSuccess:(NSDictionary *)userInfo
{
    NSString *accessToken = userInfo[@"access_token"];
    NSString *expires_in = [NSString stringWithFormat:@"%@",userInfo[@"expires_in"]];
    NSString *refresh_token = userInfo[@"refresh_token"];
    NSString *openID = userInfo[@"openid"];
    
    if ( accessToken.length == 0 || expires_in.length == 0 || refresh_token.length == 0 || openID.length == 0 )
    {
       [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        return;
    }
    
    EVThirdPartUserInfo *userModel = [[EVThirdPartUserInfo alloc] init];
    userModel.type = EVThirdPartUserInfoWeixin;
    userModel.access_token = accessToken;
    userModel.expires_in = expires_in;
    userModel.refresh_token = refresh_token;
    userModel.openID = openID;
    
    __weak typeof(self) wself = self;
    [[EV3rdPartAPIManager sharedManager] getTirdPartUserInfo:userModel start:^ {
        [EVProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } success:^(EVThirdPartUserInfo *userInfo) {
        [wself thirdPartUserLoginWith:userInfo];
        [EVProgressHUD hideHUDForView:wself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        [self loginFailed:@{kErrorInfo : kQQAuthFail}];
        [EVProgressHUD showError:kFail_login toView:wself.view];
    }];
}

//第三方登录
- (void)thirdPartUserLoginWith:(EVThirdPartUserInfo *)userInfo
{
    EVUseLoginAuthtype type = (EVUseLoginAuthtype)userInfo.type;
    __weak typeof(self) wself = self;
    //__weak typeof(wself.navigationController) wnav = wself.navigationController;
    NSDictionary *loginDic = [userInfo userLoginParams];
    [self.engine GETThirdPartLoginWithType:type params:loginDic  start:^{
        [EVProgressHUD showMessage:kGettingThirdPartUserInfo toView:wself.view];
    } fail:^(NSError *error) {
        NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
        [[EVAlertManager shareInstance] performComfirmTitle:errorStr message:nil comfirmTitle:kOK WithComfirm:nil];
        [EVProgressHUD hideHUDForView:wself.view];
    } success:^(EVLoginInfo *loginInfo) {
//        [EVProgressHUD hideHUDForView:wself.view];
        EVLog(@"denglu---------------   %@",loginInfo.name);
        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
//        [EVBugly setUserId:loginInfo.name];
//        [EVNotificationCenter postNotificationName:NotifyOfLogin object:nil];
//        [loginInfo synchronized];
//        if ( loginInfo.hasLogin )
//        {
//            [loginInfo synchronized];
//            if ( wself.autoDismiss )
//            {
//                if ( wnav )
//                {
//                    [wnav dismissViewControllerAnimated:YES completion:nil];
//                }
//                else
//                {
//                    [wself dismissViewControllerAnimated:YES completion:nil];
//                }
//                [EVBaseToolManager notifyLoginViewDismiss];
//                return ;
//            }
//            [wself gotoHomePage];
//            return ;
//        }
//        [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [wself gotoUserSettingWithLoginInfo:loginInfo];
          [EVProgressHUD hideHUDForView:wself.view];
        if (loginInfo.hasLogin) {
            
            [wself dismissViewControllerAnimated:YES completion:nil];
            [EVBugly setUserId:loginInfo.name];
            [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
            loginInfo.phone = wself.loginView.PhoneTextFiled.text;
            [loginInfo synchronized];
            [wself gotoHomePage];
            [wself loginEMIMInfo:loginInfo];
            [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
        }else {
             [self newUserRegister:loginInfo];
        }
//        [EVProgressHUD hideHUDForView:wself.view];
//        [wself dismissViewControllerAnimated:YES completion:nil];
//        [EVBugly setUserId:loginInfo.name];
//        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
//        loginInfo.phone = wself.loginView.PhoneTextFiled.text;
//        [loginInfo synchronized];
//        [wself gotoHomePage];
//        [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
    }];
}



- (void)attributedLabelButton
{
    EVPhoneRegistFirstController *phoneRegistVC = [[EVPhoneRegistFirstController alloc] init];
    [self.navigationController pushViewController:phoneRegistVC animated:YES];
}



- (void)newUserRegister:(EVLoginInfo *)info
{
    WEAK(self)
    [self.engine GETNewUserRegistMessageWithParams:[self userInfoDict:info] start:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"logining_user_information") toView:weakself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:weakself.view];
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_user_information")];
        [EVProgressHUD showError:errorStr toView:weakself.view];
    } success:^(EVLoginInfo *loginInfo) {
        loginInfo.registeredSuccess = YES;
        EVLog(@"denglu---------------   %@",loginInfo.name);
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
        [weakself dismissViewControllerAnimated:YES completion:nil];
        //        }
    }];
}

- (void)upLoadLogoImage
{
//    [EVProgressHUD hideHUDForView:self.view];
//    __weak typeof(self) wself = self;
//    [self.engine GETUploadUserLogoWithImage:self.userInfo.selectImage uname:self.userInfo.nickname start:^{
//        [EVProgressHUD showMessage:kE_GlobalZH(@"update_image") toView:wself.view];
//        
//    } fail:^(NSError *error) {
//        [EVProgressHUD hideHUDForView:wself.view];
//        self.barButtonItem.enabled = YES;
//        self.upDateImageError = YES;
//        NSString *customErrorInfo = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_update_image")];
//        if ( customErrorInfo ) {
//            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:customErrorInfo comfirmTitle:kOK WithComfirm:nil];
//        } else {
//            [EVProgressHUD showError:kE_GlobalZH(@"again_fail_update_image") toView:wself.view];
//        }
//    } success:^(NSDictionary *retinfo){
//        self.barButtonItem.enabled = YES;
//        wself.upDateImageError = NO;
//        wself.userInfo.logourl = retinfo[@"logourl"];
//        [EVNotificationCenter postNotificationName:CCUpdateLogolURLNotification object:nil userInfo:retinfo];
//        [wself.userInfo synchronized];
//        [EVProgressHUD hideHUDForView:wself.view];
//        [EVProgressHUD showSuccess:kE_GlobalZH(@"update_iamge_success") toView:wself.view];
//        [wself upLoadLogoSuccess];
//        
//    } sessionExpire:^{
//        self.barButtonItem.enabled = YES;
//    }];
}


- (NSMutableDictionary *)userInfoDict:(EVLoginInfo *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   
   
    if ([info.authtype isEqualToString:@"phone"]) {
         NSString *userName = [NSString stringWithFormat:@"%@%@",@"火眼财经",[info.phone substringWithRange:NSMakeRange(7, 4)]];
         [dict setValue:userName forKey:@"nickname"];
        NSString *phone  = [NSString stringWithFormat:@"86_%@",info.phone];
        [dict setValue:phone forKey:kToken];
        [dict setValue:info.password forKey:kPassword];
    }else {
        if (info.token) {
            [dict setValue:info.token forKey:kToken];
        }
        if (info.nickname) {
            [dict setValue:info.nickname forKey:kNickName];
        }
        
        if (info.access_token) {
            [dict setValue:info.access_token forKey:kAccess_token];
        }
        
        if (info.gender) {
            [dict setValue:info.gender forKey:kGender];
        }
        
        if (info.birthday) {
             [dict setValue:info.birthday forKey:kBirthday];
        }
        
        if (info.location) {
            [dict setValue:info.location forKey:kLocation];
        }
       
        if (info.signature) {
            [dict setValue:info.signature forKey:kLocation];
        }
        if (info.logourl) {
            [dict setValue:info.logourl forKey:kLogourl];
        }
   
    }
   
    [dict setValue:info.authtype forKey:kAuthType];
    return dict;
}


- (void) gotoUserSettingWithLoginInfo:(EVLoginInfo *)info
{
    EVUserSettingViewController *settingVC = [EVUserSettingViewController userSettingViewController];
    settingVC.title = kEdit_user_info;
    settingVC.userInfo = info;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)gotoHomePage
{
    if ( self.navigationController )
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setUpHomeController];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setUpHomeController];
    }
    [EVBaseToolManager notifyLoginViewDismiss];
}

- (void)loginFailed:(NSDictionary *)userInfo
{
    
    NSString *errorInfo = userInfo[kErrorInfo];
    if ( [errorInfo isEqualToString:kQQAuthFail] )
    {
    }
    else if ( [errorInfo isEqualToString:kQQAuthCancel] )
    {
    }
    else if ( [errorInfo isEqualToString:kQQAuthNoNetWork] )
    {
    
    } else if ( [errorInfo isEqualToString:kWeixinAuthFail] )
    {
        
    }
    else if ( [errorInfo isEqualToString:kWeiXinAuthCancel] )
    {
    
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthCancel] )
    {
        
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthDeny] )
    {
        
    }
    else if ( [errorInfo isEqualToString:kWeiBoAuthFail] )
    {
        
    }
}

@end
