//
//  EVSettingLivingPWDView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVSettingLivingPWDView.h"
#import "PureLayout.h"
#import "EVTextField.h"

#define ANIMATION_DURATION 0.3

@interface EVSettingLivingPWDView ()<UITextFieldDelegate, EVTextFieldDelegate>

@property (weak, nonatomic) UIView *pwdContainerV;  /**< 密码容器 */
@property (weak, nonatomic) UITextField *pwdInputTfd;  /**< 密码隐形的输入框 */
@property (strong, nonatomic) NSArray *pwdLblArr; /**< 存放密码显示的label */
@property (copy, nonatomic) NSMutableString *pwdStrM;  /**< 密码字符串 */

@property (nonatomic, assign) BOOL destroyed;

@property (nonatomic,copy) void(^completeBlock)(NSString *password);

@end

@implementation EVSettingLivingPWDView

@synthesize pwdStrM = _pwdStrM;

#pragma mark - public class methods

+ (void)showAndCatchResultWithSuperView:(nonnull UIView *)superView offsetY:(CGFloat)offsetY complete:(void(^_Nullable)(NSString *_Nullable password))complete
{
    EVSettingLivingPWDView *pwdV = [[EVSettingLivingPWDView alloc] initWithFrame:CGRectMake(0, superView.bounds.size.height, superView.bounds.size.width, superView.bounds.size.height)];
    [superView addSubview:pwdV];
    
    pwdV.completeBlock = complete;
    CGRect frame = pwdV.frame;
    frame.origin.y = offsetY;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        pwdV.frame = frame;
    }];
}


#pragma mark - public instance methods

- (void)showAndCatchResult:(void (^)(NSString *))complete
{
    if ( self.destroyed )
    {
        return;
    }
    self.completeBlock = complete;
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.frame = frame;
    }];
}


#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setUpUI];
    }
    
    return self;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CCLog(@"textfield:%@， string:%@", textField.text, string);
    
    if ( self.lastPwd.length > 0 )
    {
        self.lastPwd = nil;
    }
    
    if ( range.location >= self.pwdLblArr.count )
    {
        return NO;
    }
    
    NSMutableString *pwdTempM = [self.pwdStrM mutableCopy];
    [pwdTempM replaceCharactersInRange:range withString:string];
    textField.text = pwdTempM;
    self.pwdStrM = pwdTempM;
    
    // 去除当前密码输入页面
    if ( self.pwdStrM.length >= self.pwdLblArr.count )
    {
        [self delegateResponseToPasswordDidChangeMethod];
    }
    
    return NO;
}


#pragma mark - EVTextFieldDelegate

- (void)backspacePressedBeforeDeleting:(NSString *)deleteBeforeStr afterDeleting:(NSString *)afterDeleteStr
{
    if ( deleteBeforeStr.length < 1 )
    {
        self.pwdStrM = nil;
    }
}


#pragma mark - event response

// 取消
- (void)cancel
{
    self.pwdStrM = nil;
    
    [self delegateResponseToPasswordDidChangeMethod];
}

// 确定
- (void)confirm
{
    // 判断密码是否符合规则
    if ( self.pwdStrM.length != self.pwdLblArr.count )
    {
        // 提示完善密码位数
        [CCProgressHUD showError:@"密码不符合规则，请完善或修改！"];
        
        return;
    }
    
    // 代理响应
    [self delegateResponseToPasswordDidChangeMethod];
}


#pragma mark - private methods

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 01. 添加控件
    // 顶部类似导航条
    UIView *navBarV = [[UIView alloc] initWithFrame:CGRectZero];
    navBarV.backgroundColor = [UIColor colorWithHexString:kGlobalNaviBarBgColorStr];
    [self addSubview:navBarV];
    
    // 去除状态栏的view
    UIView *navBottomV = [[UIView alloc] initWithFrame:CGRectZero];
    navBottomV.backgroundColor = [UIColor clearColor];
    [navBarV addSubview:navBottomV];
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:CCTextBlackColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:17.0f];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [navBottomV addSubview:cancelBtn];
    
    // 确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:CCTextBlackColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:17.0f];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [navBottomV addSubview:confirmBtn];
    
    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.textColor = [UIColor colorWithHexString:@"#222222"];
    title.font = [[CCAppSetting shareInstance] normalFontWithSize:17.0f];
    title.text = @"请输入密码";
    [self addSubview:title];
    
    // 盛放密码的view
    UIView *pwdContainerV = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:pwdContainerV];
    pwdContainerV.backgroundColor = [UIColor clearColor];
    
    // 添加密码显示控件
    CGFloat pwdLblH = 57.0f;
    UILabel *pwdLbl_1 = [[UILabel alloc] initWithFrame:CGRectZero];
    [pwdContainerV addSubview:pwdLbl_1];
    UILabel *pwdLbl_2 = [[UILabel alloc] initWithFrame:CGRectZero];
    [pwdContainerV addSubview:pwdLbl_2];
    UILabel *pwdLbl_3 = [[UILabel alloc] initWithFrame:CGRectZero];
    [pwdContainerV addSubview:pwdLbl_3];
    UILabel *pwdLbl_4 = [[UILabel alloc] initWithFrame:CGRectZero];
    [pwdContainerV addSubview:pwdLbl_4];
    self.pwdLblArr = @[pwdLbl_1, pwdLbl_2, pwdLbl_3, pwdLbl_4];
    for (UILabel *pwdLbl in self.pwdLblArr)
    {
//        pwdLbl.text = @"-";
//        pwdLbl_1.backgroundColor = [UIColor blueColor];
        pwdLbl.textColor = [UIColor colorWithHexString:@"#222222"];
        pwdLbl.font = [UIFont boldSystemFontOfSize:17.0f];
        pwdLbl.textAlignment = NSTextAlignmentCenter;
        pwdLbl.layer.borderWidth = 1.0f;
        pwdLbl.layer.cornerRadius = pwdLblH / 2;
        pwdLbl.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    }
    
    // 隐形的输入框
    EVTextField * pwdInputTfd = [[EVTextField alloc] initWithFrame:CGRectZero];
    pwdInputTfd.keyboardType = UIKeyboardTypeNumberPad;
    pwdInputTfd.secureTextEntry = YES;  // 加上这句系统会强行不适用第三方键盘
    pwdInputTfd.tintColor = [UIColor clearColor];
    pwdInputTfd.textColor = [UIColor clearColor];
    [pwdInputTfd becomeFirstResponder];
    pwdInputTfd.delegate = self;
    pwdInputTfd.customeDelegate = self;
    [pwdContainerV addSubview:pwdInputTfd];
    
    
    // 02. 设置控件间的约束
    // 顶部类似导航条
    [navBarV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [navBarV autoSetDimension:ALDimensionHeight toSize:64.0f];
    
    // 导航条的除状态栏的部分
    [navBottomV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [navBottomV autoSetDimension:ALDimensionHeight toSize:44.0f];
    
    // 取消按钮
    [cancelBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeRight];
    [cancelBtn autoSetDimension:ALDimensionWidth toSize:60.0f];
    
    // 确定按钮
    [confirmBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f) excludingEdge:ALEdgeLeft];
    [confirmBtn autoSetDimension:ALDimensionWidth toSize:60.0f];
    
    // 标题
    [title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:navBottomV withOffset:53.0f];
    [title autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 盛放密码的view
    [pwdContainerV autoPinEdge:ALEdgeTop
                        toEdge:ALEdgeBottom
                        ofView:title withOffset:40.0f];
//    [pwdContainerV autoSetDimension:ALDimensionWidth toSize:pwdContainerVW];
    [pwdContainerV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // 密码显示控件
    CGFloat spaceW = ( ScreenWidth - pwdLblH * 4 ) / ( 3 + 1.5 + 1.5 );
    [pwdLbl_1 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:pwdLbl_1.superview];
    [pwdLbl_1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [pwdLbl_1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [pwdLbl_1 autoSetDimensionsToSize:CGSizeMake(pwdLblH, pwdLblH)];
    [pwdLbl_2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pwdLbl_1 withOffset:spaceW];
    [pwdLbl_3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pwdLbl_2 withOffset:spaceW];
    [pwdLbl_4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pwdLbl_3 withOffset:spaceW];
    [pwdLbl_4 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [self.pwdLblArr autoMatchViewsDimension:ALDimensionHeight];
    [self.pwdLblArr autoMatchViewsDimension:ALDimensionWidth];
    [self.pwdLblArr autoAlignViewsToEdge:ALEdgeTop];
    
    // 隐形的输入框
    [pwdInputTfd autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)showPwdInLabelsWithPwd:(NSString *)pwdstr
{
    if ( pwdstr.length > self.pwdLblArr.count )
    {
        return;
    }
    
    for (int i = 0; i < self.pwdLblArr.count; ++i)
    {
        UILabel *pwdLbl = self.pwdLblArr[i];
        pwdLbl.text = nil;
    }
    
    for (int i = 0; i < pwdstr.length; ++i)
    {
        UILabel *pwdLbl = self.pwdLblArr[i];
        pwdLbl.text = [pwdstr substringWithRange:NSMakeRange(i, 1)];
    }
}

// 代理响应更改密码完成的方法
- (void)delegateResponseToPasswordDidChangeMethod
{
    self.destroyed = YES;
    [self endEditing:YES];
    if ( self.completeBlock )
    {
        self.completeBlock(self.pwdStrM);
        self.completeBlock = nil;
    }
    else if ( _delegate && [_delegate respondsToSelector:@selector(passwordDidChange:)] )
    {
        [_delegate passwordDidChange:self.pwdStrM];
    }
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - getters and setters

- (NSMutableString *)pwdStrM
{
    if ( !_pwdStrM )
    {
        _pwdStrM = [NSMutableString string];
    }
    
    return _pwdStrM;
}

- (void)setPwdStrM:(NSMutableString *)pwdStrM
{
    if ( ![_pwdStrM isEqualToString:pwdStrM] )
    {
        _pwdStrM = [pwdStrM copy];
        
        // 在labels上展示密码
        [self showPwdInLabelsWithPwd:pwdStrM];
    }
}

- (void)setLastPwd:(NSString *)lastPwd
{
    if ( ![_lastPwd isEqualToString:lastPwd] )
    {
        _lastPwd = [lastPwd mutableCopy];
        
        self.pwdStrM = [_lastPwd mutableCopy];
        self.pwdInputTfd.text = [_lastPwd mutableCopy];
    }
}

@end
