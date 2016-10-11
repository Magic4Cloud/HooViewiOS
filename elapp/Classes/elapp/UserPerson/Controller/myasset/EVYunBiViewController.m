//
//  EVYunBiViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVYunBiViewController.h"
#import <PureLayout.h>
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVPayManager.h"
#import "EVProductInfoModel.h"
#import "EVConsumptionDetailsController.h"
#import "EVUserAsset.h"
#import "EVBaseToolManager+EVLiveAPI.h"
#import "EVBaseToolManager+EVlogAPI.h"
#import "NSString+Extension.h"
#import "TTTAttributedLabel.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

typedef enum : NSUInteger {
    CCYibiSelectedWeixinPay = 100,
    CCYibiSelectedAppPay,
} CCYibiSelectedPayWay;

#define CCYibiSelectedButtonColor [UIColor colorWithHexString:@"#fb6655"]

@interface EVYunBiViewController ()<UITableViewDelegate, UITableViewDataSource,EVPayManagerDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) UIImageView *headBgView;  /**< 余额显示容器 */
@property (weak, nonatomic) UILabel *moneyLbl;  /**< 余额展示label */
@property (weak, nonatomic) UIView *payWayContainer;  /**< 充值方式容器 */
@property (weak, nonatomic) UIView *payMoneySelectContainer;  /**< 充值金额选择区 */
@property (weak, nonatomic) UIButton *weixinPayBtn;  /**< 微信支付选择按钮 */
@property (weak, nonatomic) UIButton *appPayBtn;  /**< 苹果支付选择按钮 */
@property (assign, nonatomic) CCYibiSelectedPayWay payWay; /**< 支付方式 */

@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求管理引擎 */
@property (strong, nonatomic) NSMutableArray *weixinPricesArrM; /**< 微信价格列表 */
@property (strong, nonatomic) NSMutableArray *appPayPricesArrM; /**< 苹果支付列表 */
@property (strong, nonatomic) EVProductInfoModel *lastSelectedProduct; /**< 上次选择的产品 */
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *lastCell;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;


@property (weak, nonatomic) UIButton *countButton;

@end

@implementation EVYunBiViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setUpViews];
    
    // 请求数据，展示购买列表
    [self loadPayWaysData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = kE_GlobalZH(@"ecoin_recharge");
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"recharge_money_record") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
    [rightBarBtnItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15.0],UITextAttributeTextColor:[UIColor evSecondColor]} forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    if (self.isPresented) {
        UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
        [leftBarBtnItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15.0]} forState:(UIControlStateNormal)];
        self.navigationItem.leftBarButtonItem = leftBarBtnItem;
    }
}

- (void)leftBarBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    [[EVPayManager sharedManager] cancelPay];
    [_engine cancelAllOperation];
    _engine = nil;
    _weixinPricesArrM = nil;
    _appPayPricesArrM = nil;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.appPayPricesArrM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"kCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
        cell.textLabel.font = CCNormalFont(14);
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#403b37" alpha:0.6];
        cell.detailTextLabel.font = CCNormalFont(10);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    EVProductInfoModel *model;
   
    model = [self.appPayPricesArrM objectAtIndex:indexPath.item];
    
    NSString* bgColor = @"#ffffff";
    NSString* borderColor = @"#ff8da8";
    NSString * text = [NSString stringWithFormat:@"%zd%@", model.ecoin,kE_GlobalZH(@"e_Coin")];
    cell.textLabel.text = text;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#403b37"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%zd%@",kE_GlobalZH(@"e_give"),model.free,kE_GlobalZH(@"e_Coin")];
    NSString *money = nil;
    if ( model.rmb % 100 )
    {
        money = [NSString stringWithFormat:@"￥%.2f", model.rmb / 100.0f];
    }
    else
    {
        money = [NSString stringWithFormat:@"￥%ld", model.rmb / 100];
    }
    cell.accessoryView = [self createAccessoryViewWithText:money
                                                 textColor:borderColor
                                           backgroundColor:bgColor
                                               borderColor:borderColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeAccessoryView:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self changeAccessoryView:indexPath tableView:tableView];
}

- (void)changeAccessoryView:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    EVProductInfoModel *model1;
  
    model1 = [self.appPayPricesArrM objectAtIndex:_lastIndexPath.row];
    
    NSString *money = nil;
    if ( model1.rmb % 100 )
    {
        money = [NSString stringWithFormat:@"￥%.2f", model1.rmb / 100.0f];
    }
    else
    {
        money = [NSString stringWithFormat:@"￥%ld", model1.rmb / 100];
    }
    _lastCell.accessoryView = [self createAccessoryViewWithText:money
                                                      textColor:@"#ffffff"
                                                backgroundColor:@"#ff8da8"
                                                    borderColor:@"#ff8da8"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    EVProductInfoModel *model;
 
    model = [self.appPayPricesArrM objectAtIndex:indexPath.row];
    
    NSString *rmb = nil;
    if ( model.rmb % 100 )
    {
        rmb = [NSString stringWithFormat:@"￥%.2f", model.rmb / 100.0f];
    }
    else
    {
        rmb = [NSString stringWithFormat:@"￥%ld", model.rmb / 100];
    }
    cell.accessoryView = [self createAccessoryViewWithText:rmb
                                                 textColor:@"#ffffff"
                                           backgroundColor:@"#ff8da8"
                                               borderColor:@"#ff8da8"];
    
    _lastIndexPath = indexPath;
    _lastCell = cell;
    _lastSelectedProduct = model;
}

- (UILabel *) createAccessoryViewWithText:(NSString* ) text
                                textColor:(NSString* ) textColor
                          backgroundColor:(NSString* ) bgColor
                              borderColor:(NSString* ) borderColor
{
    UILabel *btn = [[UILabel alloc] init];
    btn.text = text;
    btn.textAlignment = NSTextAlignmentCenter;
    btn.textColor = [UIColor colorWithHexString:textColor];
    btn.font = [UIFont systemFontOfSize:12.f];
    btn.backgroundColor = [UIColor colorWithHexString:bgColor];
    btn.frame = CGRectMake(0.f, 0.f, 70.f, 23.f);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor colorWithHexString:borderColor].CGColor;
    btn.layer.borderWidth = 1.f;
    return btn;
}

#pragma mark - CCPayManagerDelegate

- (void)weixinPayDidSucceed
{
    
    [self regetAssetsAfterWeixinPaySuccess];
}

- (void)weixinPayDidFailWithFailType:(EVPayFailedType)failType
                         failMessage:(NSString *)failMessage
{
    [CCProgressHUD hideHUDForView:self.view];
    switch ( failType )
    {
        case EVPayFailedTypeUnknown:
        {
            
        }
            break;
            
        case EVPayFailedTypeError:
        {
            [CCProgressHUD showError:failMessage toView:self.view];
        }
            break;
            
        case EVPayFailedTypeCancel:
        {
            
        }
            break;
    }
}

- (void)appPayDidSucceedWithEcoin:(NSInteger)ecoin
{
    // 重新请求余额数据
    CCLog(@"苹果支付成功，重新请求余额数据");
    
    [self regetAssetsAfterWeixinPaySuccess];
}

- (void)appPayDidFailWithFailType:(EVPayFailedType)failType
                      failMessage:(NSString *)failMessage
{
    [CCProgressHUD hideHUDForView:self.view];
    switch ( failType )
    {
        case EVPayFailedTypeUnknown:
        {
            
        }
            break;
            
        case EVPayFailedTypeError:
        {
            [CCProgressHUD showError:failMessage toView:self.view];
        }
            break;
            
        case EVPayFailedTypeCancel:
        {
            
        }
            break;
    }
}

- (void)appPayInProcessing
{
    
}


#pragma mark - event response


- (void)appPayClicked:(UIButton *)btn
{
    if ( self.payWay == CCYibiSelectedAppPay)
    {
        return;
    }
    self.lastSelectedProduct = nil;
    btn.backgroundColor = CCYibiSelectedButtonColor;
    btn.selected = YES;
    self.weixinPayBtn.backgroundColor = [UIColor whiteColor];
    self.weixinPayBtn.selected = NO;
    
    self.payWay = CCYibiSelectedAppPay;
    _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadData];
}

- (void)commitToPay:(UIButton *)btn
{
    if ( !self.lastSelectedProduct )
    {
        return;
    }
    
    [EVPayManager sharedManager].delgate = self;
    [CCProgressHUD showProgressMumWithClearColorToView:self.view];
    // 购买
    switch ( self.payWay )
    {
        case CCYibiSelectedWeixinPay:
        {
            [[EVPayManager sharedManager] payByWeiXinWithOder:self.lastSelectedProduct];
        }
            break;
            
        case CCYibiSelectedAppPay:
        {
            if ( [NSString isBlankString:self.lastSelectedProduct.productid] )
            {
                return;
            }
            NSDictionary *moreInfoDict = @{CCProductID : self.lastSelectedProduct.productid};
            [self.engine POSTPayLogWithType:@"product buy button"
                                  state:@"clicked"
                               moreInfo:moreInfoDict];
            
            [[EVPayManager sharedManager] payByInAppPurchase:self.lastSelectedProduct];
        }
            break;
            
        default:
            break;
    }
}

//充值记录
- (void)rightBarBtnClick
{
        EVConsumptionDetailsController *ctrl = [[EVConsumptionDetailsController alloc] init];
        ctrl.type = EVDetailType_prepaid;
        [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma mark - private methods

- (void)regetAssetsAfterWeixinPaySuccess
{
    [CCProgressHUD hideHUDForView:self.view];
    [CCProgressHUD showProgressMumWithClearColorToView:self.view
                                               message:kE_GlobalZH(@"pay_success_ecoin_gain")];
    __weak typeof(self) weakSelf = self;
    [self.engine GETUserAssetsWithStart:nil fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:weakSelf.view];
        [CCProgressHUD showError:kE_GlobalZH(@"please_see_asset") toView:weakSelf.view];
     } success:^(NSDictionary *info) {
         [CCProgressHUD hideHUDForView:weakSelf.view];
         NSString *buyEcoin = [NSString stringWithFormat:kE_GlobalZH(@"bug_ecoin"), weakSelf.lastSelectedProduct.ecoin];
         [CCProgressHUD showSuccess:buyEcoin toView:weakSelf.view];
         EVUserAsset *asset = [EVUserAsset objectWithDictionary:info];
         weakSelf.asset.ecoin = asset.ecoin;
          NSString *moneyStr = [NSString stringWithFormat:@"%zd云币",self.asset.ecoin];
         
         if (weakSelf.updateEcionBlock) {
             weakSelf.updateEcionBlock([NSString stringWithFormat:@"%ld", weakSelf.asset.ecoin]);
         }
         [_countButton setTitle:moneyStr forState:UIControlStateNormal];
         NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
         [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyStr.length - 2, 2)];
         [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
          [_countButton setAttributedTitle:attStr forState:(UIControlStateNormal)];
         if ( weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(buySuccessWithEcoin:)] )
         {
             [weakSelf.delegate buySuccessWithEcoin:weakSelf.asset.ecoin];
         }
     } sessionExpire:^{
         [CCProgressHUD hideHUDForView:weakSelf.view];
         CCRelogin(weakSelf);
     }];
}

- (void)setUpViews
{
    self.view.backgroundColor = [UIColor evBackgroundColor];
    
    CGFloat height = 160.f;
    

    UIImageView *headBgView = [[UIImageView alloc] init];
    headBgView.frame = CGRectMake(0, 10, ScreenWidth, height);
    headBgView.backgroundColor = [UIColor whiteColor];
    headBgView.userInteractionEnabled = YES;
    [self.view addSubview:headBgView];
    _headBgView = headBgView;
    
    // 添加余额显示
    // 余额展示label
    UILabel *moneyLbl = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH1] font:CCNormalFont(15.0f)];
    [headBgView addSubview:moneyLbl];
//    moneyLbl.font = [UIFont systemFontOfSize:18.0];
    self.moneyLbl = moneyLbl;
    [moneyLbl autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headBgView withOffset:40];
    [moneyLbl autoAlignAxis:ALAxisVertical toSameAxisOfView:headBgView];
    [moneyLbl autoSetDimension:ALDimensionHeight toSize:20.0];
    moneyLbl.text = kE_GlobalZH(@"account_difference");
    
    NSString *moneyStr = [NSString stringWithFormat:@"%zd%@",self.asset.ecoin,kE_Coin];
    UIButton *countButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    countButton.backgroundColor = [UIColor clearColor];
    countButton.userInteractionEnabled = NO;
    [countButton setTitle:moneyStr forState:UIControlStateNormal];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(moneyStr.length - 2, 2)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor evTextColorH1] range:NSMakeRange(0, attStr.length)];
    countButton.titleLabel.font = [UIFont systemFontOfSize:34.0];
    [countButton setAttributedTitle:attStr forState:(UIControlStateNormal)];
    [countButton setImage:[UIImage imageNamed:@"personal_icon_myeasymoney_whitegold"] forState:UIControlStateNormal];
    [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [countButton setImageEdgeInsets:UIEdgeInsetsMake(.0f, -2.0f, .0f, 2.0f)];
    [countButton setTitleEdgeInsets:UIEdgeInsetsMake(.0f, 2.0f, .0f, -2.0f)];
    [headBgView addSubview:countButton];
    [countButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:moneyLbl withOffset:30];
    [countButton autoAlignAxis:ALAxisVertical toSameAxisOfView:headBgView];
    _countButton = countButton;
}

- (void)loadPayWaysData
{
    // 根据返回数据判断是否展示除内购外的支付方式和对应数据：如果只支持内购，则不显示支付方式选项栏；如果支持多种方式支付，则显示支付方式选项栏，并且底部用多个view来展示不同支付方式
    __weak typeof(self) weakself = self;
    //选择all可能会有其他充值方式
    [self.engine GETCashinOptionWith:CCPayPlatformAll start:^{
        
    } fail:^(NSError *error) {
    } success:^(NSDictionary *info) {
        CCLog(@"info:%@", info);
        NSArray *optionListTemp = info[@"optionlist"];
        NSArray *optionList = [EVProductInfoModel objectWithDictionaryArray:optionListTemp];
        [weakself handleOptionList:optionList];
    } sessionExpired:^{
        CCRelogin(weakself);
    }];
}

- (void)handleOptionList:(NSArray *)optionList
{
    for (EVProductInfoModel *product in optionList)
    {
        if ( product.platform == 1 )
        {
            [self.weixinPricesArrM addObject:product];
        }
        else if ( product.platform == 2 )
        {
            [self.appPayPricesArrM addObject:product];
        }
    }
    
    if ( self.weixinPricesArrM.count > 0 || self.appPayPricesArrM.count > 0 )
    {
        [self addMoreUI];
    }
    
    if ( self.weixinPricesArrM.count > 0 )
    {
        self.payWay = CCYibiSelectedWeixinPay;
    }
    else
    {
        self.payWay = CCYibiSelectedAppPay;
    }
}

- (void)addMoreUI
{

//    
    // 展示支付钱数列表
    UILabel *payMoneyTitleLbl = [UILabel labelWithDefaultTextColor:[UIColor evTextColorH2] font:CCNormalFont(13.0f)];
    [self.view addSubview:payMoneyTitleLbl];
    CGFloat payWayTitleLblY = CGRectGetMaxY(self.headBgView.frame);
    if ( self.payWayContainer )
    {
        payWayTitleLblY = CGRectGetMaxY(self.payWayContainer.frame);
    }
    payMoneyTitleLbl.frame = CGRectMake(15.0f, payWayTitleLblY + 5, ScreenWidth, 25.0f);
    payMoneyTitleLbl.text = kE_GlobalZH(@"please_change_ecoin");
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.frame = CGRectMake(0.f, CGRectGetMaxY(payMoneyTitleLbl.frame) + 5, ScreenWidth, self.view.frame.size.height - CGRectGetMaxY(payMoneyTitleLbl.frame));
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor evBackgroundColor];
    tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    tableView.delegate = self;
    tableView.bounces = NO;
    tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    footerView.backgroundColor = [UIColor evBackgroundColor];
    // 充值确认按钮
    UIButton *commitBtn = [[UIButton alloc] init];
    commitBtn.layer.cornerRadius = 3;
    [commitBtn addTarget:self action:@selector(commitToPay:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:16];
    [commitBtn setTitle:kE_GlobalZH(@"affirm_recharge") forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.backgroundColor = [UIColor evMainColor];
    [footerView addSubview:commitBtn];
    [commitBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.f];
    [commitBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [commitBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [commitBtn autoSetDimension:ALDimensionHeight toSize:40.0f];

    TTTAttributedLabel *noteLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [footerView addSubview:noteLbl];
    [noteLbl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:commitBtn withOffset:10];
    [noteLbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView withOffset:20];
    [noteLbl autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 40];
    noteLbl.numberOfLines = 0;
    noteLbl.textColor = [UIColor evTextColorH2];
    noteLbl.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString: kE_GlobalZH(@"recharge_tip")];
    NSMutableParagraphStyle *paragraghStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraghStyle setLineSpacing:6];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor evTextColorH2],NSParagraphStyleAttributeName:paragraghStyle} range:NSMakeRange(0, attrStr.length)];
    noteLbl.attributedText = attrStr;
    
     tableView.tableFooterView = footerView;
}

#pragma mark - getters and setters

- (EVBaseToolManager *)engine
{
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (NSMutableArray *)weixinPricesArrM
{
    if (!_weixinPricesArrM)
    {
        _weixinPricesArrM = [NSMutableArray array];
    }
    
    return _weixinPricesArrM;
}

- (NSMutableArray *)appPayPricesArrM
{
    if (!_appPayPricesArrM)
    {
        _appPayPricesArrM = [NSMutableArray array];
    }
    
    return _appPayPricesArrM;
}


@end
