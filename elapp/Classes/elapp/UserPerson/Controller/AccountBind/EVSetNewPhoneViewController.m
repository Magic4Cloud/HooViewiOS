//
//  EVSetNewPhoneViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSetNewPhoneViewController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVGetVirifyCodeView.h"
#import <PureLayout.h>
#import "EVRegionCodeModel.h"
#import "EVSelectRegionViewController.h"
#import "EVBaseToolManager+EVAccountChangeAPI.h"

@interface EVSetNewPhoneViewController ()<CCSelectRegionViewControllerDelegate>

@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (weak, nonatomic) EVGetVirifyCodeView *verifyCodeView;  /**< 验证码视图 */
@property (weak, nonatomic) UITextField *phoneInputField;  /**< 手机号输入框 */
@property (assign, nonatomic) NSInteger timeLength; /**< 走表的最大值 */
@property (copy, nonatomic) NSString *smsId; /**< 验证码id */
@property (assign, nonatomic) BOOL isCheckingSmsId; /**< 是否正在校验验证码 */
@property (copy, nonatomic) NSString *newpPhone;  /**< 新手机号 */
@property (weak, nonatomic) UILabel *regionLbl;  /**< 国际区号 */
@property (nonatomic, strong) EVRegionCodeModel *currRegion;

@end

@implementation EVSetNewPhoneViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
}


#pragma mark - CCSelectRegionViewControllerDelegate

- (void)selectRegiton:(EVRegionCodeModel *)region
{
    self.currRegion = region;
}


#pragma mark - event response

- (void)commit
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
        __strong typeof(weakself) strongSelf = weakself;
        strongSelf.isCheckingSmsId = NO;
        
        [strongSelf changeNewPhoneWithNewPhone:strongSelf.newpPhone];
    }];
}

- (void)getVerifyCode
{
    if ( self.timeLength != 60 )
    {
        return;
    }
    
    // 开始走表
    [EVNotificationCenter addObserver:self selector:@selector(modifyTime) name:EVUpdateTime object:nil];
    
    NSString *newPhone = [NSString stringWithFormat:@"%@_%@", self.currRegion.area_code, self.phoneInputField.text];
    
    self.newpPhone = [newPhone mutableCopy];

    // 请求发送验证码
    __weak typeof(self) wself = self;
    [self.engine GETSmssendWithAreaCode:nil Phone:newPhone type:PHONE phoneNumError:^(NSString *numError) {
        
    } start:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"get_verify") toView:wself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"verify_fail")] toView:wself.view];
    } success:^(NSDictionary *info) {
        [EVProgressHUD hideHUDForView:wself.view];
        
        if ([info[kRegistered]  isEqual: @(1)])     // 手机号已被绑定
        {
            [EVProgressHUD showError:kE_GlobalZH(@"phone_num_binding_account") toView:wself.view];
            return;
        }
        
        [EVProgressHUD showSuccess:kE_GlobalZH(@"verify_send_phone") toView:wself.view];
        if ( info[kSms_id] != nil )
        {
            NSNumber *smsId = info[kSms_id];
            wself.smsId = [smsId stringValue];
        }
    }];
}

- (void)gotoChooseRegionPage
{
    EVSelectRegionViewController *selectRegionVC = [[EVSelectRegionViewController alloc] init];
    selectRegionVC.delegate = self;
    [self.navigationController pushViewController:selectRegionVC animated:YES];
}


#pragma mark - private methods

- (void)setUpUI
{
    self.title = kE_GlobalZH(@"change_new_phone_num");
    self.timeLength = 60;
    
    // 国际区号
    UIView *regionContainer = [[UIView alloc] init];
    regionContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:regionContainer];
    [regionContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [regionContainer autoSetDimension:ALDimensionHeight toSize:55.0f];
    // 区号label
    UILabel *regionLbl = [UILabel labelWithDefaultTextColor:[UIColor textBlackColor] font:EVNormalFont(14.0f)];
    [regionContainer addSubview:regionLbl];
    self.regionLbl = regionLbl;
    [regionLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, 16.0f, .0f, .0f)];
    // 右侧indicator
    UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_find_back"]];
    [regionContainer addSubview:indicator];
    [indicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16.0f];
    [indicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    // 响应点击
//    UIButton *regionBtn = [[UIButton alloc] init];
//    [regionContainer addSubview:regionBtn];
//    [regionBtn addTarget:self action:@selector(gotoChooseRegionPage) forControlEvents:UIControlEventTouchUpInside];
//    [regionBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    // 手机号输入框顶部分割线
    UIView *regionTopLine = [[UIView alloc] init];
    regionTopLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [regionContainer addSubview:regionTopLine];
    [regionTopLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [regionTopLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
    // 新手机号
    UIView *phoneContainer = [[UIView alloc] init];
    phoneContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneContainer];
    [phoneContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:regionContainer];
    [phoneContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [phoneContainer autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [phoneContainer autoSetDimension:ALDimensionHeight toSize:55.0f];
    // 左侧图片
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_icon_phone"]];
    [phoneContainer addSubview:icon];
    [icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
    [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [icon autoSetDimensionsToSize:CGSizeMake(12.5f, 15.0f)];
    // 手机号输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.placeholder = kE_GlobalZH(@"enter_new_phone_num");
    textField.font = EVNormalFont(14.0f);
    textField.tintColor = [UIColor textBlackColor];
    [phoneContainer addSubview:textField];
    [textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:icon withOffset:16.0f];
    [textField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.phoneInputField = textField;
    // 手机号输入框顶部分割线
    UIView *phoneTopLine = [[UIView alloc] init];
    phoneTopLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [phoneContainer addSubview:phoneTopLine];
    [phoneTopLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [phoneTopLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
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
    [verifyView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneContainer withOffset:0.0f];
    [verifyView autoSetDimension:ALDimensionHeight toSize:55.0f];
    
    // 设置默认国际区号
    EVRegionCodeModel *defaultRegion = [[EVRegionCodeModel alloc] init];
    defaultRegion.contry_name = kEChina;
    defaultRegion.area_code = @"86";
    self.currRegion = defaultRegion;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundColor:[UIColor evMainColor]];
    [nextBtn setTitle:kE_GlobalZH(@"carry_out") forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 20;
    nextBtn.clipsToBounds = YES;
    [self.view addSubview:nextBtn];
    [nextBtn autoSetDimension:ALDimensionHeight toSize:40];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:57];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:57];
    [nextBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:verifyView withOffset:72];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
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

- (void)changeNewPhoneWithNewPhone:(NSString *)newPhone
{
    __weak typeof(self) weakself = self;
    [self.engine GETAuthPhoneChangeWithPhone:newPhone startBlock:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"change_phone_num") toView:weakself.view];
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:weakself.view];
    } success:^(NSDictionary *dict) {
        [EVProgressHUD hideHUDForView:weakself.view];
        [weakself.navigationController popToRootViewControllerAnimated:NO];
    } sessionExpire:^{
        [EVProgressHUD hideHUDForView:weakself.view];
    }];
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

- (void)setCurrRegion:(EVRegionCodeModel *)currRegion
{
    _currRegion = currRegion;
    self.regionLbl.text = [NSString stringWithFormat:@"%@ +%@", _currRegion.contry_name, _currRegion.area_code];
}

@end
