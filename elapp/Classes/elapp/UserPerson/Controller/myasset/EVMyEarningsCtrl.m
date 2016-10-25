//
//  EVMyEarningsCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVMyEarningsCtrl.h"
#import "ALView+PureLayout.h"
#import "EVWebViewCtrl.h"
#import "EVUserAsset.h"
#import "EVConsumptionDetailsController.h"
#import "EVWithdrawNumCtrl.h"
#import "EVStartResourceTool.h"
#import "EVAlertManager.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVLoadingView.h"

typedef NS_ENUM(NSUInteger, EVMyEarningsCtrlBtnType)
{
    EVMyEarningsCtrlBtnType_back = 1000,
    EVMyEarningsCtrlBtnType_right,
    EVMyEarningsCtrlBtnType_withdraw,
    EVMyEarningsCtrlBtnType_crash,
    EVMyEarningsCtrlBtnType_qa
};

@interface EVMyEarningsCtrl ()

@property (nonatomic, weak) UILabel *withdrawAmountLabel;
@property (nonatomic, weak) UILabel *nowWithdrawAmountLabel;
@property (nonatomic, weak) UILabel *fantuanNumLabel;

@property (nonatomic, copy) NSString *withdrawAmount;
@property (nonatomic, copy) NSString *nowWithdrawAmount;
@property (nonatomic, copy) NSString *fantuanNum;

@property (strong, nonatomic) EVBaseToolManager *engine;
@property ( weak, nonatomic ) EVLoadingView *loadingView;

@end

@implementation EVMyEarningsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCBackgroundColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self navBar];
    [self mainView];
}

- (void)dealloc
{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserAssetsWithStart:nil fail:^(NSError *error)
     {
         [weakSelf.loadingView showFailedViewWithClickBlock:^{
             [weakSelf loadData];
         }];
     } success:^(NSDictionary *videoInfo) {
         
         [weakSelf.loadingView destroy];
         EVUserAsset *asset = [EVUserAsset objectWithDictionary:videoInfo];
         weakSelf.userAsset = asset;
     } sessionExpire:^{
         
     }];
}

- (void) navBar
{
    self.title = kE_GlobalZH(@"me_earnings");
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"push_money_record") style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    [rightBarBtnItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15.0],UITextAttributeTextColor:[UIColor whiteColor]} forState:(UIControlStateNormal)];
    rightBarBtnItem.tag = EVMyEarningsCtrlBtnType_right;
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

- (void) mainView
{
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    bgView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 1.f);
    bgView.showsHorizontalScrollIndicator = NO;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self.view addSubview:bgView];
    
    CGFloat height = 160.0f;
    UIView *totalCashView = [[UIView alloc] init];
    [bgView addSubview:totalCashView];
    totalCashView.backgroundColor = [UIColor whiteColor];
    [totalCashView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [totalCashView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [totalCashView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [totalCashView autoSetDimension:ALDimensionHeight toSize:height];
    
    UILabel *label = [self createLabel:kE_GlobalZH(@"can_money") font:15.f textColor:@"#262626"];
    label.font = [UIFont systemFontOfSize:15];
    [totalCashView addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:41.f];
    
    UILabel *withdrawAmountLabel = [self createLabel:self.withdrawAmount font:34.f textColor:@"#262626"];
    [totalCashView addSubview:withdrawAmountLabel];
    [withdrawAmountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [withdrawAmountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:30.f];
    self.withdrawAmountLabel = withdrawAmountLabel;
    
    UIView *seperatorLine = [UIView new];
    [totalCashView addSubview:seperatorLine];
    seperatorLine.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [seperatorLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalCashView];
    [seperatorLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:totalCashView];
    [seperatorLine autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
    
    
    UIView *todayCashView = [[UIView alloc] init];
    todayCashView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:todayCashView];
    [todayCashView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:totalCashView withOffset:0];
    [todayCashView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
    [todayCashView autoSetDimension:ALDimensionWidth toSize:ScreenWidth];
    [todayCashView autoSetDimension:ALDimensionHeight toSize:height];
    
    UILabel *label1 = [self createLabel:kE_GlobalZH(@"today_money") font:15.f textColor:@"#262626"];
    [todayCashView addSubview:label1];
    [label1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:todayCashView withOffset:41.f];
    
    UILabel *nowWithdrawAmountLabel = [self createLabel:self.nowWithdrawAmount font:34.f textColor:@"#262626"];
    [todayCashView addSubview:nowWithdrawAmountLabel];
    [nowWithdrawAmountLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nowWithdrawAmountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label1 withOffset:30.f];
    self.nowWithdrawAmountLabel = nowWithdrawAmountLabel;
    
//    UIButton *qaBtn = [[UIButton alloc] init];
//    [qaBtn setTitle:kE_GlobalZH(@"common_question") forState:UIControlStateNormal];
//    [qaBtn setTitleColor:[UIColor colorWithHexString:@"#858585"] forState:UIControlStateNormal];
//    qaBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    qaBtn.tag = EVMyEarningsCtrlBtnType_qa;
//    [qaBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:qaBtn];
//    [qaBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-10.f];
//    [qaBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.layer.cornerRadius = 4.f;
    [shadowBtn setTitle:kE_GlobalZH(@"wechat_money") forState:UIControlStateNormal];
    shadowBtn.backgroundColor = CCColor(98, 45, 128);
    [shadowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shadowBtn.tag = EVMyEarningsCtrlBtnType_withdraw;
    [shadowBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shadowBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [bgView addSubview:shadowBtn];
    [shadowBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-30.f];
    [shadowBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shadowBtn autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 40.f];
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
            
        case EVMyEarningsCtrlBtnType_back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case EVMyEarningsCtrlBtnType_right:
        {
            EVConsumptionDetailsController *ctrl = [[EVConsumptionDetailsController alloc] init];
            ctrl.type = EVDetailType_withdrawal;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
            
        case EVMyEarningsCtrlBtnType_withdraw:
        {
            if (self.userAsset.cashstatus == 0) {
                [CCProgressHUD showError:kE_GlobalZH(@"account_money_frost")];
                return;
            } else if( self.userAsset.limitcash < 200){
                [[EVAlertManager shareInstance] performComfirmTitle:kE_GlobalZH(@"once_not_two_money") message:nil comfirmTitle:kOK WithComfirm:nil];
                return;
            }
            
            EVWithdrawNumCtrl *ctrl = [[EVWithdrawNumCtrl alloc] init];
            ctrl.nowWithdrawAmount = [NSString stringWithFormat:@"%.2f", self.userAsset.limitcash/100.0];
            ctrl.weixinFee = self.userAsset.feerate / 10000;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
            
        case EVMyEarningsCtrlBtnType_qa:
        {
            EVWebViewCtrl *webCtrl = [[EVWebViewCtrl alloc] init];
            webCtrl.title = kE_GlobalZH(@"common_question");
            webCtrl.requestUrl = [[EVStartResourceTool shareInstance] payFAQUrl];
            if ([[EVStartResourceTool shareInstance] payFAQUrl]) {
                [self.navigationController pushViewController:webCtrl animated:YES];
            }else {
                [CCProgressHUD showError:@"url为空"];
            }
            
        }
            break;
            
 
            
        default:
            break;
    }
}

- (NSString *)withdrawAmount
{
    return [NSString stringWithFormat:@"￥ %.2f", self.userAsset.cash/100.0];
}

- (NSString *)nowWithdrawAmount
{
    return [NSString stringWithFormat:@"￥ %.2f", self.userAsset.limitcash/100.0];
}

- (NSString *)fantuanNum
{
    return [NSString stringWithFormat:@"%zd", self.userAsset.riceroll];
}

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (EVLoadingView *)loadingView
{
    if ( _loadingView == nil )
    {
        EVLoadingView *loadingView = [[EVLoadingView alloc] init];
        [self.view addSubview:loadingView];
        [loadingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.loadingView = loadingView;
    }
    return _loadingView;
}

- (void)setUserAsset:(EVUserAsset *)userAsset
{
    _userAsset = userAsset;
    self.withdrawAmountLabel.text = self.withdrawAmount;
    self.nowWithdrawAmountLabel.text = self.nowWithdrawAmount;
}

@end
