//
//  EVChangePWDViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVChangePWDViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVAlertManager.h"
#import "EVBaseToolManager+EVAccountChangeAPI.h"

#define CCChangePWDViewControllerTitle @"title"
#define CCChangePWDViewControllerPlaceHolder @"placeHolder"
#define CCChangePWDViewControllerTag @"tag"

typedef enum : NSUInteger {
    EVChangePWDTagOld = 100,
    EVChangePWDTagNew,
    EVChangePWDTagReinput,
} EVChangePWDTag;

@interface EVChangePWDViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UIView *container;  /**< 容器视图 */
@property (weak, nonatomic) UITextField *oldPWDField;  /**< 原密码框 */
@property (weak, nonatomic) UITextField *newpPWDField;  /**< 新密码框 */
@property (weak, nonatomic) UITextField *reinputField;  /**< 新密码确认框 */
@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (assign, nonatomic) BOOL isRequesting; /**< 是否正在请求 */

@end

@implementation EVChangePWDViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
}


#pragma mark - event response

- (void)commit
{
    if ( self.isRequesting )
    {
        return;
    }
    
    [self.container endEditing:YES];
    
    __weak typeof(self) weakself = self;
    // 判断老密码是否合乎规则，为空则提示用户输入
    if ( self.oldPWDField.text.length < 6 || self.newpPWDField.text.length >= 20)
    {
        [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"password_lessthan_six_num_again_enter") comfirmTitle:kOK WithComfirm:^{
            [weakself.oldPWDField becomeFirstResponder];
        }];
        
        return;
    }
    
    // 判断新密码是否合乎规则，为空则提示用户输入
    if (self.newpPWDField.text.length == 0) {
        [EVProgressHUD showError:@"提示请输入新密码"];
        return;
    }
    if ( self.newpPWDField.text.length < 6 || self.newpPWDField.text.length >= 20)
    {
        [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"password_lessthan_six_num_again_enter") comfirmTitle:kOK WithComfirm:^{
            [weakself.newpPWDField becomeFirstResponder];
        }];
        
        return;
    }
    
    // 判断确认密码是否与新密码一致，不一致的话提示用户重新输入
    if ( ![self.newpPWDField.text isEqualToString:self.reinputField.text] )
    {
        [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"enter_new_password_two_same_again_enter") comfirmTitle:kOK WithComfirm:^{
            [weakself.reinputField becomeFirstResponder];
        }];
        
        return;
    }
    
    weakself.isRequesting = YES;
    [self.engine POSTModifyPasswordWithOldPwd:self.oldPWDField.text newPwd:self.newpPWDField.text startBlock:^{
        weakself.isRequesting = NO;
        [EVProgressHUD showProgressMumWithClearColorToView:weakself.view];
    } fail:^(NSError *error) {
        weakself.isRequesting = NO;
        [EVProgressHUD hideHUDForView:weakself.view];
        NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"motify_fail")];
        if ([errorStr isEqualToString:@"授权失败"]) {
           [EVProgressHUD showError:@"修改失败"];
            return;
        }
        [EVProgressHUD showError:errorStr];
    } success:^(NSDictionary *dict) {
        weakself.isRequesting = NO;
        [EVProgressHUD hideHUDForView:weakself.view];
        [weakself.navigationController popViewControllerAnimated:YES];
    } sessionExpire:^{
        weakself.isRequesting = NO;
        [EVProgressHUD hideHUDForView:weakself.view];
        EVRelogin(weakself);
    }];
}


#pragma private methods

- (void)setUpUI
{
    self.title = kE_GlobalZH(@"motify_password");
    
    // 右上角完成按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ ",kE_GlobalZH(@"carry_out")] style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [rightItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor evMainColor],UITextAttributeFont:[UIFont systemFontOfSize:15.f]} forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 输入密码页面
    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:container];
    self.container = container;
//    [container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    NSArray *titleAndPlaceholder = @[@{CCChangePWDViewControllerTitle : kE_GlobalZH(@"old_password"),
                                       CCChangePWDViewControllerPlaceHolder : kE_GlobalZH(@"enter_password_please"),
                                       CCChangePWDViewControllerTag : @(EVChangePWDTagOld)
                                       },
                                     @{CCChangePWDViewControllerTitle : kE_GlobalZH(@"new_password"),
                                       CCChangePWDViewControllerPlaceHolder : kE_GlobalZH(@"num_and_char_six"),
                                       CCChangePWDViewControllerTag : @(EVChangePWDTagNew)
                                       },
                                     @{CCChangePWDViewControllerTitle : kE_GlobalZH(@"confirm_password"),
                                       CCChangePWDViewControllerPlaceHolder : kE_GlobalZH(@"confirm_password"),
                                       CCChangePWDViewControllerTag : @(EVChangePWDTagReinput)
                                       }];
    
    for (int i = 0; i < titleAndPlaceholder.count; ++ i)
    {
        [self addTextFieldWithDictionay:titleAndPlaceholder[i] ToView:container index:i];
    }
    
    // 顶部分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [container addSubview:topLine];
    [topLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, .0f, .0f, .0f) excludingEdge:ALEdgeBottom];
    [topLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
}

- (void)addTextFieldWithDictionay:(NSDictionary *)dict ToView:(UIView *)container index:(NSInteger)index
{
    CGFloat x = 16.0f;
    CGFloat y = 10.0f;
    CGFloat titleWith = 75.0f;
    CGFloat height = 55.0f;
    y += 55.0f * index;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(.0f, y, ScreenWidth, height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [container addSubview:bottomView];
    
    UILabel *title = [UILabel labelWithDefaultTextColor:[UIColor textBlackColor] font:EVNormalFont(14.0f)];
    title.frame = CGRectMake(x, y, titleWith, height);
    title.text = dict[CCChangePWDViewControllerTitle];
    [container addSubview:title];
    
    x += titleWith;
    // 输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x , y, ScreenWidth - x, height)];
    textField.placeholder = dict[CCChangePWDViewControllerPlaceHolder];
    textField.font = EVNormalFont(14.0f);
    textField.secureTextEntry = YES;
    textField.tintColor = [UIColor textBlackColor];
    textField.delegate = self;
    textField.tag = [((NSNumber *)dict[CCChangePWDViewControllerTag]) integerValue];
    [container addSubview:textField];
    
    switch ( textField.tag )
    {
        case EVChangePWDTagOld:
        {
            self.oldPWDField = textField;
        }
            break;
            
        case EVChangePWDTagNew:
        {
            self.newpPWDField = textField;
        }
            break;
            
        default:
        {
            self.reinputField = textField;
        }
            break;
    }
    
    // 底部分割线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(.0f, y + height - .5f, ScreenWidth, kGlobalSeparatorHeight)];
    bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [container addSubview:bottomLine];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1) {
        return YES;
    }else if (textField.text.length >= 20) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.oldPWDField resignFirstResponder];
    [self.newpPWDField resignFirstResponder];
    [self.reinputField resignFirstResponder];
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
