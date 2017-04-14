//
//  EVPhoneLoginViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPhoneLoginViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVLoginInfo.h"
#import "AppDelegate.h"
#import <PureLayout.h>
#import "EVRegionCodeModel.h"
#import "EVSelectRegionViewController.h"
#import "EVPhoneLoginView.h"
#import "EVPhoneRegistFirstController.h"
#import "EVBugly.h"
#import "NSString+Extension.h"
#import "EVAlertManager.h"
#import "EVSDKInitManager.h"

@interface EVPhoneLoginViewController () <UITextFieldDelegate, CCSelectRegionViewControllerDelegate,EVPhoneLogDelegate>

@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, strong) EVRegionCodeModel *currRegion;
@property (nonatomic, weak) EVPhoneLoginView *phoneLogin;

@end

@implementation EVPhoneLoginViewController

#pragma mark - life cycle
+ (instancetype)phoneLoginViewController
{
    EVPhoneLoginViewController *phonelogin = [[EVPhoneLoginViewController alloc] init];
    return phonelogin;
}

- (void)dealloc
{
    EVLog(@"%@ dealloc", [self class]);
    _engine = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kE_Login;
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
    
    [self phoneLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 充值密码后，回到登陆需要带回来手机号
    // 选择完区号以后也需要继续存在已经输入的手机号
    NSInteger subFromLocation = 0;
    if ([self.phone cc_containString:@"_"])
    {
        subFromLocation = [self.phone rangeOfString:@"_"].location + 1;
    }
    self.phone = [self.phone substringFromIndex:subFromLocation];
    self.phoneLogin.phoneText.text = self.phone ? self.phone : @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (EVPhoneLoginView *) phoneLogin
{
    if (!_phoneLogin)
    {
        EVPhoneLoginView *phoneLogin = [[EVPhoneLoginView alloc] init];
        phoneLogin.delegate = self;
        [self.view addSubview:phoneLogin];
        _phoneLogin = phoneLogin;
        [phoneLogin autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0];
        [phoneLogin autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 74)];
        [phoneLogin autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    }
    return _phoneLogin;
}

#pragma mark - CCSelectRegionViewControllerDelegate
- (void)selectRegiton:(EVRegionCodeModel *)region
{
    _phoneLogin.contryAndCodelabel.text = [NSString stringWithFormat:@"%@ +%@",region.contry_name ,region.area_code];
    self.currRegion = region;
}

#pragma mark - 手机登录
- (void)login:(NSString *)password phoneNumber:(NSString *)phoneNumber
{
    NSString *phone = phoneNumber;
    NSString *pwd = password;

    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    [EVProgressHUD showMessage:kLogin_loading toView:wself.view];
    [self.engine GETPhoneUserPhoneLoginWithAreaCode:@"86" Phone:phone password:pwd phoneNumError:^(NSString *numError) {
         [EVProgressHUD showError:numError toView:self.view];
    }  start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        NSString *errorStr = [error errorInfoWithPlacehold:kFail_login];
         [[EVAlertManager shareInstance] performComfirmTitle:errorStr message:nil comfirmTitle:kOK WithComfirm:nil];
    } success:^(EVLoginInfo *loginInfo) {
        [EVProgressHUD hideHUDForView:wself.view];
        [EVBugly setUserId:loginInfo.name];
        [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
        loginInfo.phone = wself.phoneLogin.phoneText.text;
        [loginInfo synchronized];
        [wself gotoHomePage];
    }];
}

- (void)phoneLoginView:(EVPhoneLoginView *)loginView clickButtonWithTag:(EVPhoneLoginViewTag)tag phoneNum:(NSString *)phoneNumber password:(NSString *) password
{
    switch (tag)
    {
        case EVPhoneLoginButton:
        {
            [self login:password phoneNumber:phoneNumber];
        }
            break;
            
        case EVSelectRegionButton:
        {
            EVSelectRegionViewController *selectRegionVC = [[EVSelectRegionViewController alloc] init];
            selectRegionVC.delegate = self;
            self.phone = self.phoneLogin.phoneText.text;
            [self.navigationController pushViewController:selectRegionVC animated:YES];
        }
            break;
            
        case EVForgotPasswordButton:
        {
            [self gotoPWDResetPage];
        }
            break;
            
        default:
            break;
    }
}

- (void)gotoPWDResetPage
{
    EVPhoneRegistFirstController *resetVC = [EVPhoneRegistFirstController phoneRegistFirstController];
    resetVC.resetPWD = YES;
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (void)gotoHomePage
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setUpHomeController];
    [EVBaseToolManager notifyLoginViewDismiss];
}

#pragma mark - event response
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - setter and getter
- (EVBaseToolManager *)engine {
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
