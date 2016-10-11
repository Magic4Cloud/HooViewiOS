//
//  EVBindWeixinCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVBindWeixinCtrl.h"
#import "ALView+PureLayout.h"
#import "EVWithdrawInfoCtrl.h"
#import "EVLoginInfo.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "EVAlertManager.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EV3rdPartAPIManager.h"

typedef NS_ENUM(NSUInteger, EVBindWeixinCtrlBtnType)
{
    EVBindWeixinCtrlBtnType_back = 1000,
    EVBindWeixinCtrlBtnType_next,
    EVBindWeixinCtrlBtnType_bindingWeixin
};

@interface EVBindWeixinCtrl ()

@property (nonatomic, weak) UILabel *bindTipLabel;
@property (strong, nonatomic) EVBaseToolManager *engine;
@property (weak, nonatomic) UIButton *bindWeixinBtn;  /**< 绑定微信按钮 */

@end

@implementation EVBindWeixinCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCBackgroundColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
 
    [self addWechatConfigForBindWeixinCtrlVC];
    [self navBar];
    [self mainView];
}

- (void)addWechatConfigForBindWeixinCtrlVC {
    WEAK(self);
    [[EV3rdPartAPIManager sharedManager] setWechatLoginSuccess:^(NSDictionary *callBackDic) {
        [weakself handle3rdPartNotification:callBackDic];
    }];
    [[EV3rdPartAPIManager sharedManager] setWechatLoginFailure:^(NSDictionary *callBackDic) {
        CCLog(@"%s %@", __FUNCTION__, callBackDic);
    }];
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    
    _engine = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) navBar
{
    self.title = kE_GlobalZH(@"binding_wechat");
    
}

- (void) mainView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:10.f];
    [bgView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [bgView autoSetDimension:ALDimensionHeight toSize:55.f];
    
    UILabel *label = [self createLabel:kE_GlobalZH(@"binding_wechat") font:15.f textColor:@"#5d5854"];
    [bgView addSubview:label];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:15.f];
    [label autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"personal_find_back"];
    [bgView addSubview:imageView];
    [imageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-15.f];
    [imageView autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    
    UILabel *bindTipLabel = [self createLabel:kE_GlobalZH(@"not_binding") font:15.f textColor:@"#fb6655"];
    [bgView addSubview:bindTipLabel];
    [bindTipLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:imageView withOffset:-5.f];
    [bindTipLabel autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    self.bindTipLabel = bindTipLabel;
    
    UIButton *bindingBtn = [[UIButton alloc] init];
    bindingBtn.tag = EVBindWeixinCtrlBtnType_bindingWeixin;
    [bindingBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bindingBtn];
    [bindingBtn autoSetDimensionsToSize:CGSizeMake(80.f, 55.f)];
    [bindingBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.f];
    [bindingBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView];
    self.bindWeixinBtn = bindingBtn;
    
    UILabel *label1 = [self createLabel:kE_GlobalZH(@"binding_wechat_embody_red_pack_send_wechat_account") font:12.f textColor:@"#8b847e"];
    [self.view addSubview:label1];
    [label1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:15.f];
    [label1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:bgView withOffset:10.f];
    
    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.layer.borderColor = [UIColor colorWithHexString:kGlobalGreenColor].CGColor;
    shadowBtn.layer.borderWidth = 1.f;
    shadowBtn.layer.cornerRadius = 20.f;
    [shadowBtn setTitle:kE_GlobalZH(@"next") forState:UIControlStateNormal];
    [shadowBtn setTitleColor:[UIColor colorWithHexString:kGlobalGreenColor] forState:UIControlStateNormal];
    shadowBtn.tag = EVBindWeixinCtrlBtnType_next;
    [shadowBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shadowBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.view addSubview:shadowBtn];
    [shadowBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label1 withOffset:55.f];
    [shadowBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shadowBtn autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 30.f];
    [shadowBtn autoSetDimension:ALDimensionHeight toSize:40.f];
}

- (UILabel *) createLabel:(NSString *) text font:(CGFloat)fontSize textColor:(NSString *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithHexString:textColor];
    return label;
}

- (void) buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case EVBindWeixinCtrlBtnType_back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case EVBindWeixinCtrlBtnType_next:
        {
            if (![self isBindingWeixin]) {
                [[EVAlertManager shareInstance] performComfirmTitle:nil message:kE_GlobalZH(@"need_binding_wechat_extract_money") comfirmTitle:kOK WithComfirm:nil];
            } else {
                EVWithdrawInfoCtrl *ctrl = [[EVWithdrawInfoCtrl alloc] init];
                ctrl.withdrawAmount = self.withdrawAmount;
                ctrl.weixinFee = self.weixinFee;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
        }
            break;
        case EVBindWeixinCtrlBtnType_bindingWeixin:
            [[EV3rdPartAPIManager sharedManager] weixinLoginWithViewController:self];
            break;
            
        default:
            break;
    }
}

- (BOOL) isBindingWeixin
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    for (EVRelationWith3rdAccoutModel *authModel in loginInfo.auth) {
        if ([authModel.type isEqualToString:@"weixin"]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)handle3rdPartNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"weixin" forKey:kType];
    NSString *token = userInfo[@"access_token"];
    NSString *expireTime = userInfo[@"expires_in"];
    [params setValue:token forKey:@"access_token"];
    [params setValue:@"weixin" forKey:kType];
    [params setValue:expireTime forKey:@"expires_in"];
    [params setValue:userInfo[@"refresh_token"] forKey:@"refresh_token"];
    [params setValue:userInfo[@"openid"] forKey:@"token"];
    [params setValue:userInfo[kUnionid] forKey:kUnionid];
    
    __weak typeof(self) weakself = self;
    [self.engine GETUserBindWithParams:params start:^{
        [CCProgressHUD showMessage:kE_GlobalZH(@"binding_wechat_account_please_wait") toView:weakself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:weakself.view];
        [CCProgressHUD showError:[error errorInfoWithPlacehold:kE_GlobalZH(@"fail_binding")] toView:weakself.view];
    } success:^{
        [CCProgressHUD hideHUDForView:weakself.view];
        weakself.bindTipLabel.text = kE_GlobalZH(@"alreddy_binding");
        weakself.bindWeixinBtn.userInteractionEnabled = NO;
        EVLoginInfo *loginInfo = [EVLoginInfo localObject];
        EVRelationWith3rdAccoutModel *authModel = [[EVRelationWith3rdAccoutModel alloc] init];
        authModel.type = @"weixin";
        authModel.token = token;
        authModel.expire_time = expireTime;
        authModel.login = NO;
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:loginInfo.auth];
        [arrM addObject:authModel];
        loginInfo.auth = arrM;
        [loginInfo synchronized];
    } sessionExpire:^{
        [CCProgressHUD hideHUDForView:weakself.view];
        CCRelogin(weakself);
    }];
}

#pragma getters and setters

- (EVBaseToolManager *)engine {
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

@end
