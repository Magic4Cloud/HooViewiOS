//
//  EVVerifyCodeViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/28.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVVerifyCodeViewController.h"
#import "EVBaseLoginView.h"
#import "EVHVVerifyCodeView.h"
#import "EVPasswordController.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVLoginInfo.h"
@interface EVVerifyCodeViewController ()<EVHVVerifyCodeViewDelegate>

@property (nonatomic, weak) EVHVVerifyCodeView *verifyCodeView;

@property (nonatomic, strong) EVBaseToolManager *engine;

@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, assign) NSInteger timeLength;

@end

@implementation EVVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  
    [self loadXibView];
    // 开始走表
    self.timeStr = @"没有收到短信? 再次发送";
    self.timeLength = 60;
    [EVNotificationCenter addObserver:self selector:@selector(modifyTime) name:EVUpdateTime object:nil];
}

- (void)loadXibView
{
    EVBaseLoginView *baseLoginView = [[[NSBundle mainBundle] loadNibNamed:@"EVBaseLoginView" owner:nil options:nil] lastObject];
    [self.view addSubview:baseLoginView];
    baseLoginView.frame = CGRectMake(0, 0, ScreenWidth, 400);
    baseLoginView.closeClick = ^(id close){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    EVHVVerifyCodeView *verifyCodeView = [[[NSBundle mainBundle] loadNibNamed:@"EVHVVerifyCodeView" owner:nil options:nil] lastObject];
    [self.view addSubview:verifyCodeView];
    self.verifyCodeView = verifyCodeView;
    verifyCodeView.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 100);
    verifyCodeView.delegate = self;
}


- (void)nextButtonUserInfo:(EVLoginInfo *)info
{
    EVPasswordController *passwordVC = [[EVPasswordController alloc] init];
    passwordVC.loginInfo = info;
    passwordVC.verifyCode = self.verifyCodeView.codeTextFiled.text;
    passwordVC.resetPWD = self.resetPWD;
    [self.navigationController pushViewController:passwordVC animated:YES];
}


- (void)newRegist
{
    if (self.verifyCodeView.codeTextFiled.text.length < 4) {
        [EVProgressHUD showOnlyTextMessage:@"请输入验证码" forView:self.view];
        return;
    }
    NSString *verfifyCode = [NSString stringWithFormat:@"%@",self.verifyCodeView.codeTextFiled.text];
    __weak typeof(self) wself = self;
    [EVProgressHUD hideHUDForView:self.view];
    NSString *Phone = self.phoneNum;
    
    [self.view endEditing:YES];
    NSString *infoToken = [NSString stringWithFormat:@"%@_%@",@"86",Phone];
    // 校验验证码
    NSString *sms_id = [[NSUserDefaults standardUserDefaults] objectForKey:kSms_id];
    [self.engine getSmsverifyWithSmd_id:sms_id sms_code:verfifyCode start:^{
    } fail:^(NSError *error) {
        if (![error.domain isEqualToString:kBaseToolDomain]) {
            [EVProgressHUD showError:@"您的网络异常\n请稍后再试"];
            return ;
        }
         NSString *message = [error errorInfoWithPlacehold:kFail_verify];
        [EVProgressHUD showError:message toView:wself.view];
        if (error.code == -1003) {
            [EVProgressHUD showError:@"您的网络异常\n请稍后再试"];
            return;
        }
    } success:^{
        [EVProgressHUD hideHUDForView:wself.view];
        EVLoginInfo *info = [[EVLoginInfo alloc] init];
        info.token = infoToken;
        info.phone = [NSString stringWithFormat:@"%@",Phone];
        info.authtype = @"phone";
        [wself nextButtonUserInfo:info];
    }];
}

- (void)modifyTime
{
    
    if (self.timeLength <= 1) {
        [EVNotificationCenter removeObserver:self];
        [self.verifyCodeView.timeButton setEnabled:YES];
        NSString *sendStr = @"没有收到短信? 点击再次发送";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",sendStr]];
        //修改某个范围内字的颜色
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH1]  range:NSMakeRange(0,12)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor evMainColor]  range:NSMakeRange(8, 6)];
        [self.verifyCodeView.timeButton setAttributedTitle:str forState:(UIControlStateNormal)];
        return;
    }

    self.timeLength -= 1;
    NSString *timeS = [NSString stringWithFormat:@"%@ (%ld秒)",self.timeStr,self.timeLength];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",timeS]];
    //修改某个范围内字的颜色
    NSRange rang = self.timeLength < 10 ? NSMakeRange(13,4) : NSMakeRange(13,5);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH1]  range:NSMakeRange(0,12)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor evMainColor]  range:rang];
    [self.verifyCodeView.timeButton setAttributedTitle:str forState:(UIControlStateNormal)];
    [self.verifyCodeView.timeButton setEnabled:NO];
    
    
}

- (void)timeButton:(UIButton *)btn
{
    if ( self.resetPWD )
    {
        [self sendVerfiCodeToPhone:self.phoneNum messageType:RESETPWD];
    }
    else
    {
        [self sendVerfiCodeToPhone:self.phoneNum messageType:PHONE];
    }
    
}

- (void)sendVerfiCodeToPhone:(NSString *)phone messageType:(SMSTYPE)type
{
    
    __weak typeof(self) wself = self;
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneNum = phone;
    
    [self.engine GETSmssendWithAreaCode:@"86" Phone:phone type:type phoneNumError:^(NSString *numError) {
        [EVProgressHUD showError:numError toView:self.view];
    } start:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"sending_verify_num")  toView:wself.view];
    } fail:^(NSError *error) {
        //注册失败上报错误日志给后台
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showError:@"验证码发送失败"];
    } success:^(NSDictionary *info) {
        [EVProgressHUD hideHUDForView:wself.view];
        // 持久化验证码id，防止用户切出去后，id为空，验证会失败
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *str = [NSString stringWithFormat:@"%@",info[kSms_id]];
        if ( str != nil && ![str isEqualToString:@""] && ![str isEqualToString:@"<null>"])
        {
            [ud setObject:info[kSms_id] forKey:kSms_id];
            self.timeLength = 60;
            [EVNotificationCenter addObserver:self selector:@selector(modifyTime) name:EVUpdateTime object:nil];
        }else {
            [EVProgressHUD showError:@"获取失败"];
        }
        
    }];
}


- (void)nextButton
{
    [self newRegist];
//    EVPasswordController *passwordVC = [[EVPasswordController alloc] init];
////    passwordVC.loginInfo = info;
////    passwordVC.verifyCode = self.verifyCodeView.codeTextFiled.text;
////    passwordVC.resetPWD = self.resetPWD;
//    [self.navigationController pushViewController:passwordVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
