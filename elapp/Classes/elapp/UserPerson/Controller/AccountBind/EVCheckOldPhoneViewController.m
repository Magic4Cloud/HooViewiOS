//
//  EVCheckOldPhoneViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCheckOldPhoneViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVGetVirifyCodeView.h"
#import <PureLayout.h>
#import "EVPhoneFAQViewController.h"
#import "EVSetNewPhoneViewController.h"

@interface EVCheckOldPhoneViewController ()

@property (weak, nonatomic) EVGetVirifyCodeView *verifyCodeView;  /**< 验证码视图 */
@property (weak, nonatomic) UILabel *phoneLbl;  /**< 手机 */
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (assign, nonatomic) NSInteger timeLength; /**< 走表的最大值 */
@property (copy, nonatomic) NSString *smsId; /**< 验证码id */
@property (assign, nonatomic) BOOL isCheckingSmsId; /**< 是否正在校验验证码 */

@end

@implementation EVCheckOldPhoneViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
}

#pragma mark - event response
- (void)gotoNext
{
    if ( self.isCheckingSmsId )
    {
        return;
    }
    if ( self.smsId.length <= 0 )
    {
        return;
    }
    if ( self.verifyCodeView.verifyInputField.text.length != 4 )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"verify_fail_please_enter_new")];
        
        return;
    }
    
    self.isCheckingSmsId = YES;
    // 网络请求比对验证码，OK则进行下一步
    __weak typeof(self) weakself = self;
    [self.engine getSmsverifyWithSmd_id:self.smsId sms_code:self.verifyCodeView.verifyInputField.text start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"verify_wrong")]];
        weakself.isCheckingSmsId = NO;
    } success:^{
        weakself.isCheckingSmsId = NO;
        EVSetNewPhoneViewController *setNewPhoneVC = [[EVSetNewPhoneViewController alloc] init];
        [weakself.navigationController pushViewController:setNewPhoneVC animated:YES];
        
        if (weakself.verifyCodeView.verifyInputField.text.length > 0) {
            weakself.verifyCodeView.verifyInputField.text = nil;
        }
    }];
}

- (void)gotoPhoneFAQPage
{
    // 跳转到FAQ页面
    EVPhoneFAQViewController *FAQVC = [[EVPhoneFAQViewController alloc] init];
    FAQVC.navTitle = kE_GlobalZH(@"appeal_about");
    FAQVC.RTFFilePath = [[NSBundle mainBundle] pathForResource:@"申诉说明.rtf" ofType:nil];
    FAQVC.showAppealBtn = YES;
    [self.navigationController pushViewController:FAQVC animated:YES];
}

- (void)getVerifyCode
{
    if ( self.timeLength != 60 )
    {
        return;
    }
    
    // 开始走表
    [EVNotificationCenter addObserver:self selector:@selector(modifyTime) name:EVUpdateTime object:nil];
    
    // 请求发送验证码
    __weak typeof(self) wself = self;
    //如果oldphone为86_phone 那就别传areacode
    [self.engine GETSmssendWithAreaCode:nil Phone:self.oldPhone type:RESETPWD phoneNumError:^(NSString *numError) {
        
    } start:^{

    } fail:^(NSError *error) {
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"verify_fail")] toView:wself.view];
    } success:^(NSDictionary *info) {
        [EVProgressHUD showSuccess:kE_GlobalZH(@"verify_send_phone") toView:wself.view];
        if ( info[kSms_id] != nil )
        {
            NSNumber *smsId = info[kSms_id];
            wself.smsId = [smsId stringValue];
        }
    }];
}

/**
 *  更新验证码按钮的剩余时间
 */
- (void)modifyTime
{
    if ( self.timeLength <= 1 )
    {
        [EVNotificationCenter removeObserver:self];
        [self.verifyCodeView.verifyBtn setTitle:kE_GlobalZH(@"send_verify_num") forState:UIControlStateNormal];
        self.timeLength = 60;
        
        return;
    }
    
    self.timeLength -= 1;
    [self.verifyCodeView.verifyBtn setTitle:[NSString stringWithFormat:kE_GlobalZH(@"send_again"), self.timeLength] forState:UIControlStateNormal];
}


#pragma mark - private methods

- (void)setUpUI
{
    self.title = kE_GlobalZH(@"phone_verify");
    self.timeLength = 60;
    
    // 手机号
    UILabel *title = [UILabel labelWithDefaultTextColor:[UIColor colorWithHexString:@"#858585"] font:EVNormalFont(16.0f)];
    title.text = kE_GlobalZH(@"next_phone_receive_verify_info");
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    [title autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    
    UILabel *phone = [UILabel labelWithDefaultTextColor:[UIColor textBlackColor] font:EVNormalFont(24.0f)];
    phone.textAlignment = NSTextAlignmentCenter;
    phone.text = self.oldPhone;
    [self.view addSubview:phone];
    phone.textColor = [UIColor evMainColor];
    phone.font = [UIFont systemFontOfSize:24.];
    self.phoneLbl = phone;
    [phone autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:title withOffset:5.0f];
    [phone autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [phone autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    
    // 验证码
    EVGetVirifyCodeView *verifyView = [[EVGetVirifyCodeView alloc] init];
    verifyView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakself = self;
    verifyView.getVerifyCode = ^{
        if ( weakself.timeLength == 60 )
        {
            [weakself getVerifyCode];
        }
    };
    [self.view addSubview:verifyView];
    self.verifyCodeView = verifyView;
    [verifyView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [verifyView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [verifyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phone withOffset:20.0f];
    [verifyView autoSetDimension:ALDimensionHeight toSize:55.0f];
    
    // FAQ
    UIButton *FAQBtn = [[UIButton alloc] init];
    FAQBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:FAQBtn];
    FAQBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    FAQBtn.contentEdgeInsets = UIEdgeInsetsMake(.0f, 16.0f, .0f, .0f);
    [FAQBtn setTitle:kE_GlobalZH(@"fail_phone_not_use") forState:UIControlStateNormal];
    [FAQBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    FAQBtn.titleLabel.font = EVNormalFont(14.0f);
    [FAQBtn addTarget:self action:@selector(gotoPhoneFAQPage) forControlEvents:UIControlEventTouchUpInside];
    [FAQBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:verifyView withOffset:10.0f];
    [FAQBtn autoSetDimension:ALDimensionHeight toSize:55.0f];
    [FAQBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [FAQBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundColor:[UIColor evMainColor]];
    [nextBtn setTitle:kE_GlobalZH(@"next") forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 20;
    nextBtn.clipsToBounds = YES;
    [self.view addSubview:nextBtn];
    [nextBtn autoSetDimension:ALDimensionHeight toSize:40];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:57];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:57];
    [nextBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:FAQBtn withOffset:72];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    UIImageView *nextImageView = [[UIImageView alloc]init];
    [FAQBtn addSubview:nextImageView];
    nextImageView.image = [UIImage imageNamed:@"home_icon_next"];
    [nextImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:FAQBtn withOffset:-15];
    [nextImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:FAQBtn];
    
    
    // FAQBtn顶部分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [FAQBtn addSubview:topLine];
    [topLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [topLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    // FAQBtn顶部分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [FAQBtn addSubview:bottomLine];
    [bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeTop];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.verifyCodeView.verifyInputField resignFirstResponder];
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

- (void)setOldPhone:(NSString *)oldPhone
{
    _oldPhone = [oldPhone mutableCopy];
}

@end
