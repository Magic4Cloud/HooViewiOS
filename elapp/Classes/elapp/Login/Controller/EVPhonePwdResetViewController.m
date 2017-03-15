//
//  EVPhonePwdResetViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPhonePwdResetViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVPwdResetViewController.h"
#import "EVSelectRegionViewController.h"
#import "EVRegionCodeModel.h"
#import "EVPhoneLoginView.h"
#import "NSString+Checking.h"

typedef NS_ENUM(NSInteger, CCPhonePWDVCButtonType) {
    CCPhonePWDVCCancelButton = 100,
    CCPhonePWDVCClearPhoneTextField,
    CCPhonePWDVCGetVerifyCode,
    CCPhonePWDVCComfirm
};

@interface EVPhonePwdResetViewController () <UITextFieldDelegate, CCSelectRegionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneTextViewClearButton; //地区选择
@property (weak, nonatomic) IBOutlet UIButton *getVerifyButton;//验证码
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton; //登录

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机输入框

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIView *phoneContainerView;
@property (weak, nonatomic) IBOutlet UIView *verifyConterView;
@property (weak, nonatomic) IBOutlet UIView *regionContainer;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger seconds; // 请求验证码的时间间隔

@property (nonatomic,strong) EVBaseToolManager *engine;

@property (nonatomic, strong) EVRegionCodeModel *currRegion;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@end

@implementation EVPhonePwdResetViewController

#pragma mark - life cycle
//+ (instancetype)phonePwdResetViewController {
//    return [UIStoryboard storyboardWithName:@"CCPhonePwdResetViewController" bundle:nil].instantiateInitialViewController;
//}

- (void)dealloc {
    EVLog(@"%@ dealloc", [self class]);
    [EVNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
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
    [EVNotificationCenter addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//添加view
- (void)configView {
    
    EVPhoneLoginView *phoneView = [[EVPhoneLoginView alloc] init];
    [self.view addSubview:phoneView];
    
    [phoneView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0];
    [phoneView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0];
    [phoneView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0];
    [phoneView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0];
    
    [self addUnderLineToView:self.phoneContainerView];
    [self addUnderLineToView:self.verifyConterView];
    [self addUnderLineToView:self.regionContainer];
    
    self.getVerifyButton.layer.cornerRadius = 0.5 * self.getVerifyButton.bounds.size.height;
    self.getVerifyButton.layer.borderWidth = kGlobalSeparatorHeight;
    self.getVerifyButton.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    [self.getVerifyButton setTitleColor:[UIColor evlightGrayTextColor] forState:UIControlStateNormal];
    
    self.comfirmButton.layer.cornerRadius = 0.5 * self.comfirmButton.bounds.size.height;
    self.comfirmButton.backgroundColor = [UIColor evMainColor];
    
    self.cancelButton.tag = CCPhonePWDVCCancelButton;
    
    self.phoneTextViewClearButton.tag = CCPhonePWDVCClearPhoneTextField;
    self.getVerifyButton.tag = CCPhonePWDVCGetVerifyCode;
    self.comfirmButton.tag = CCPhonePWDVCComfirm;
    
    [self.getVerifyButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.comfirmButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneTextViewClearButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
}

- (void)setCurrRegion:(EVRegionCodeModel *)currRegion
{
    _currRegion = currRegion;
    self.regionLabel.text = [NSString stringWithFormat:@"%@ +%@", _currRegion.contry_name, _currRegion.area_code];
//    self.phoneTextField.placeholder = [NSString stringWithFormat:@"+%@手机号码", _currRegion.area_code];
    self.phoneTextField.placeholder = kLogin_phone;
}

#pragma mark - event response
- (void)textChange {
    NSString *phone = self.phoneTextField.text;
//    self.phoneTextViewClearButton.selected = [CCBaseTool checkPhoneNumByRegx:phone];
    self.phoneTextViewClearButton.selected = [phone CC_isPhoneNumberNew];
    self.phoneTextViewClearButton.userInteractionEnabled = !self.getVerifyButton.selected;
    self.phoneTextViewClearButton.hidden = !phone.length;
}

#pragma mark - CCSelectRegionViewControllerDelegate
- (void)selectRegiton:(EVRegionCodeModel *)region
{
    self.currRegion = region;
}

- (IBAction)regionCode:(UIButton *)sender
{
    EVSelectRegionViewController *selectRegionVC = [[EVSelectRegionViewController alloc] init];
    selectRegionVC.delegate = self;
    [self.navigationController pushViewController:selectRegionVC animated:YES];
}

- (void)buttonDidClicked:(UIButton *)btn {
    switch ( btn.tag )
    {
        case CCPhonePWDVCCancelButton:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case CCPhonePWDVCClearPhoneTextField:
            self.phoneTextField.text = @"";
            break;
        case CCPhonePWDVCGetVerifyCode:
            [self requestVerifyCode];
            break;
        case CCPhonePWDVCComfirm:
            [self comfirm];
            break;
        default:
            break;
    }
}

- (void)comfirm {
    NSString *phone = self.phoneTextField.text;
    NSString *verfifyCode = self.verifyTextField.text;
    if ( verfifyCode.length == 0 )
    {
        [EVProgressHUD showError:kNot_verify_num toView:self.view];
        [self.verifyTextField becomeFirstResponder];
        return;
    }
    if ( phone.length == 0 )
    {
        [EVProgressHUD showError:kNot_pbone toView:self.view];
        [self.phoneTextField becomeFirstResponder];
        return;
    }
//    else if ( ![CCBaseTool checkPhoneNumByRegx:phone] )
    else if ( ![phone CC_isPhoneNumberNew] )
    {
        [EVProgressHUD showError:kNot_format_phone toView:self.view];
        [self.phoneTextField becomeFirstResponder];
        return;
    }

    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:verfifyCode start:^{
        
    } fail:^(NSError *error) {
        NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [EVProgressHUD showError:message toView:wself.view];
    } success:^{
        [wself gotoPwdResetVC];
    }];
}

- (void)gotoPwdResetVC {
    EVPwdResetViewController *pwdResetVC = [EVPwdResetViewController pwdResetViewController];
    pwdResetVC.phone = [NSString stringWithFormat:@"%@_%@", self.currRegion.area_code, self.phoneTextField.text];
    [self.navigationController pushViewController:pwdResetVC animated:YES];
}

- (void)requestVerifyCode {
    NSString *phone = self.phoneTextField.text;
    if ( phone.length == 0 )
    {
        [EVProgressHUD showError:kNot_pbone toView:self.view];
        return;
    }
//    else if ( ![CCBaseTool checkPhoneNumByRegx:phone] )
    
    else if ( ![phone CC_isPhoneNumberNew] )
    {
        [EVProgressHUD showError:kNot_format_phone toView:self.view];
        return;
    }
    [self startCountTimer];
    [self.view endEditing:YES];
    [self sendVerfiCodeToPhone:phone];
}

- (void)sendVerfiCodeToPhone:(NSString *)phone {
    __weak typeof(self) wself = self;
    phone = [NSString stringWithFormat:@"%@_%@", self.currRegion.area_code, phone];
    [self.engine GETSmssendWithAreaCode:nil Phone:phone type:RESETPWD phoneNumError:^(NSString *numError) {
        
    } start:^{
        [EVProgressHUD showMessage:kSend_verify_num toView:wself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        NSString *message = [error errorInfoWithPlacehold:kFail_verify_num];
        [EVProgressHUD showError:message toView:wself.view];
        [wself stopFireVerifyCodeTime];
    } success:^(NSDictionary *info) {
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showSuccess:kSend_verify_success toView:wself.view];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ( info[kSms_id] != nil )
        {
            [ud setObject:info[kSms_id] forKey:kSms_id];
        }
    }];
}

- (void)startCountTimer {
    if ( self.timer == nil )
    {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateVerifyCodeButton) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.getVerifyButton.backgroundColor = [UIColor colorWithHexString:@"#d7d7d7"];
    }
    self.seconds = 60.0f;
    self.getVerifyButton.userInteractionEnabled = NO;
}

- (void)updateVerifyCodeButton {
    if ( self.seconds == 0 )
    {
        [self stopFireVerifyCodeTime];
        return;
    }
    NSString *title = [NSString stringWithFormat:kSend_again,(long)self.seconds];
    [self.getVerifyButton setTitle:title forState:UIControlStateNormal];
    self.seconds--;
}

- (void)stopFireVerifyCodeTime {
    [self.timer invalidate];
    self.timer = nil;
    self.getVerifyButton.alpha = 1.0;
    [self.getVerifyButton setTitle:[NSString stringWithFormat:@" %@ ",kSend_verify_num] forState:UIControlStateNormal];
    self.getVerifyButton.backgroundColor = [UIColor whiteColor];
    self.getVerifyButton.userInteractionEnabled = YES;
}

- (void)fillTextFieldToSuperView:(UITextField *)textField {
    [textField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:textField.superview];
    [textField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:textField.superview];
}

- (void)addUnderLineToView:(UIView *)view {
    view.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc] init];
    [view addSubview:line];
    line.backgroundColor = [UIColor evGlobalSeparatorColor];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

#pragma mark - getter and setter

- (EVBaseToolManager *)engine {
    if ( _engine == nil )
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    return _engine;
}

@end
