//
//  EVHVBiViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/12.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVBiViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVLoginInfo.h"
#import "EVLineView.h"
#import "NSString+Extension.h"
#import "CCConstKeys.h"
#import "EVConsumptionModel.h"
#import "EVYunBiViewController.h"
#import "ZWTopSelectVcView.h"
#import "EVConsumptionDetailsController.h"

@interface EVHVBiViewController ()<UITableViewDelegate,UITableViewDataSource,ZWTopSelectVcViewDelegate>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) UITableView *mTableView;

@property (nonatomic, weak) UIView *vipView;

@property (nonatomic, weak) UIView *headerView;

@property (nonatomic, weak) UILabel *nVipEcoinLabel;

@property (nonatomic, weak) UILabel *mCountLabel;

@property (nonatomic, weak) UILabel *hvBeanNumberLab;

@property (nonatomic, weak) UILabel *ecoinNameLabel;

@property (nonatomic, copy) NSString *next;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) ZWTopSelectVcView *topSelectVcView;


@end

@implementation EVHVBiViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addTableView];
    self.title = @"我的余额";
}

- (void)addTableView
{
    UIView *vipHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 154)];
    vipHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIView *incomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    incomeView.backgroundColor = [UIColor whiteColor];
    [vipHeaderView addSubview:incomeView];
    [EVLineView addBottomLineToView:incomeView];
    
    UILabel *incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 18, 100, 20)];
    incomeLabel.textColor = [UIColor colorWithHexString:@"#ff6832"];
    [incomeView addSubview:incomeLabel];
    incomeLabel.font = [UIFont systemFontOfSize:14.f];
    incomeLabel.text = @"收入";
    
    NSString *riceRoll = [NSString numFormatNumber:self.asset.riceroll];
    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",riceRoll,@"火眼币"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(moneyStr.length - kE_Coin.length, kE_Coin.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor evOrangeColor] range:NSMakeRange(0, attStr.length)];
  
    UILabel *mCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(incomeLabel.frame), 200, 50)];
    [incomeView addSubview:mCountLabel];
    mCountLabel.font = [UIFont systemFontOfSize:36.0];
    [mCountLabel setAttributedText:attStr];
    mCountLabel.textColor = [UIColor evOrangeColor];
    self.mCountLabel = mCountLabel;
    
    UIButton *drawBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [incomeView addSubview:drawBtn];
    drawBtn.frame = CGRectMake(ScreenWidth - 84, 39, 60, 24);
    [self addButtonView:drawBtn];
//    [drawBtn setTitle:@"提现" forState:(UIControlStateNormal)];
    [drawBtn addTarget:self action:@selector(drawButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIView *assetView = [[UIView alloc] initWithFrame:CGRectMake(0, 111, ScreenWidth, 44)];
    [vipHeaderView addSubview:assetView];
    
    NSString *ecoin = [NSString numFormatNumber:self.asset.ecoin];
//    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",riceRoll,@"火眼币"];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
//    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(moneyStr.length - kE_Coin.length, kE_Coin.length)];
//    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor evOrangeColor] range:NSMakeRange(0, attStr.length)];
    UILabel *ecoinLabel = [[UILabel alloc] init];
    [assetView addSubview:ecoinLabel];
    ecoinLabel.font = [UIFont systemFontOfSize:20.f];
    ecoinLabel.textColor = [UIColor hvPurpleColor];
    ecoinLabel.text = [NSString stringWithFormat:@"%@",ecoin];
    CGSize ecoinSize = [ecoinLabel sizeThatFits:CGSizeZero];
    ecoinLabel.frame = CGRectMake(24, 8, ecoinSize.width, 28);
    self.hvBeanNumberLab = ecoinLabel;
    
    UILabel *ecoinNameLabel = [[UILabel alloc] init];
    [assetView addSubview:ecoinNameLabel];
    ecoinNameLabel.font = [UIFont systemFontOfSize:14.f];
    ecoinNameLabel.textColor = [UIColor hvPurpleColor];
    ecoinNameLabel.text = @"火眼豆";
    ecoinNameLabel.frame = CGRectMake(CGRectGetMaxX(ecoinLabel.frame)+8, 12, 44, 20);
    self.ecoinNameLabel = ecoinNameLabel;
    
    UIButton *ecoinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [assetView addSubview:ecoinBtn];
    ecoinBtn.frame = CGRectMake(ScreenWidth - 84, 10, 60, 24);
    [self addButtonView:ecoinBtn];
    [ecoinBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    [ecoinBtn addTarget:self action:@selector(ecoinButton:) forControlEvents:(UIControlEventTouchUpInside)];
    

    

    
    CGFloat headerY;
    
//    if ([EVLoginInfo localObject].vip == 0) {
        UIView *nVipView =   [self addNotVipView];
        [self.view addSubview:nVipView];
        headerY = nVipView.frame.size.height;
        
//    }else {
//        [self.view addSubview:vipHeaderView];
//        headerY = vipHeaderView.frame.size.height;
//    }
    
    
    
    //第一步：初始化ZWTopSelectVcView，把其加入当前控制器view中
    ZWTopSelectVcView *topSelectVcView=[[ZWTopSelectVcView alloc]init];
    
    topSelectVcView.frame=CGRectMake(0, headerY + 1, ScreenWidth, ScreenHeight - headerY - 65);
    [self.view addSubview:topSelectVcView];
    self.topSelectVcView=topSelectVcView;
    topSelectVcView.isCloseAnimation = YES;
    
    //第二步：设置ZWTopSelectVcView的代理
    self.topSelectVcView.delegate=self;
    
    //第三步： 开始ZWTopSelectVcViewUI绘制,必须实现！
    [self.topSelectVcView setupZWTopSelectVcViewUI];
}



-(NSMutableArray *)totalControllerInZWTopSelectVcView:(ZWTopSelectVcView *)topSelectVcView
{
    
    NSMutableArray *controllerMutableArr=[NSMutableArray array];

//    EVConsumptionDetailsController *oneVC = [[EVConsumptionDetailsController alloc]init];
//    oneVC.type = EVDetailType_withdrawal;
//    oneVC.title = @"提现";
//    EVConsumptionDetailsController *twoVC = [[EVConsumptionDetailsController alloc]init];
//    twoVC.type = EVDetailType_consume;
//    twoVC.title = @"消费";
    EVConsumptionDetailsController *threeVC = [[EVConsumptionDetailsController alloc]init];
    threeVC.type = EVDetailType_prepaid;
    threeVC.title = @"充值";
//    if ([EVLoginInfo localObject].vip) {
//       [controllerMutableArr addObject:oneVC]; 
//    }
    
//    [controllerMutableArr addObject:twoVC];
    [controllerMutableArr addObject:threeVC];
    
    
    return controllerMutableArr;
}

- (void)endRefrenshing
{
    [self.mTableView endHeaderRefreshing];
    [self.mTableView endFooterRefreshing];
}


//获取充值记录
- (void)prepaidrecordsStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) wself = self;
    [self.baseToolManager  GETPrepaidRecordslistWithStart:start count:count start:^{
        
    } fail:^(NSError *error) {
        [wself endRefrenshing];
       
    } success:^(NSDictionary *info) {
        [wself requestSuccessWithIndex:start result:info];
    } sessionExpired:^{
        [wself endRefrenshing];
    }];
}

//吧请求成功的处理写在一个方法里
- (void)requestSuccessWithIndex:(NSInteger)start
                         result:(NSDictionary *)info
{
    [self endRefrenshing];
    if ( start == 0 )
    {
        [self.dataArray removeAllObjects];
    }
    self.next = info[kNext];
    [self.dataArray addObjectsFromArray:[CCConsumptionModel objectWithDictionary:info].recordlist];
    [self.mTableView setFooterState:([CCConsumptionModel objectWithDictionary:info].recordlist.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    [self.mTableView reloadData];
}



- (UIView *)addNotVipView
{
     UIView *nVipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UILabel  *ecoinCountL = [[UILabel alloc] init];
    [nVipView addSubview:ecoinCountL];
    ecoinCountL.textColor = [UIColor hvPurpleColor];
    ecoinCountL.font = [UIFont systemFontOfSize:24.f];
    NSString *riceRoll = [NSString numFormatNumber:self.asset.ecoin];
    NSString *moneyStr = [NSString stringWithFormat:@"%@ %@",riceRoll,@"火眼豆"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyStr.length - (kE_Coin.length), kE_Coin.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor hvPurpleColor] range:NSMakeRange(0, attStr.length)];
        ecoinCountL.attributedText = attStr;
    CGSize ecoinSize = [ecoinCountL sizeThatFits:CGSizeZero];

    [ecoinCountL autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [ecoinCountL autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:24];
    [ecoinCountL autoSetDimension:ALDimensionHeight toSize:33];
    [ecoinCountL autoSetDimension:ALDimensionWidth toSize:ecoinSize.width];
    
    UIButton *ecoinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [nVipView addSubview:ecoinBtn];
    ecoinBtn.frame = CGRectMake(ScreenWidth - 84, 28, 60, 24);
    [self addButtonView:ecoinBtn];
    [ecoinBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    [ecoinBtn addTarget:self action:@selector(ecoinButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return nVipView;
}

- (void)addButtonView:(UIButton *)btn
{
    btn.layer.cornerRadius = 12;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor hvPurpleColor];
 
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}

- (void)drawButton:(UIButton *)btn
{
//    NSLog(@"提现");
}

- (void)ecoinButton:(UIButton *)btn
{
//    NSLog(@"充值");
    EVYunBiViewController *yunbiVC = [[EVYunBiViewController alloc] init];
    yunbiVC.asset = self.asset;
    yunbiVC.updateEcionBlock = ^(NSString *ecion) {
        self.asset.ecoin = ecion.integerValue;
        self.hvBeanNumberLab.text = [NSString numFormatNumber:self.asset.ecoin];
        CGSize ecoinSize = [self.hvBeanNumberLab sizeThatFits:CGSizeZero];
        self.hvBeanNumberLab.frame = CGRectMake(24, 8, ecoinSize.width, 28);
        self.ecoinNameLabel.frame = CGRectMake(CGRectGetMaxX(self.hvBeanNumberLab.frame)+8, 12, 44, 20);
    };
    [self.navigationController pushViewController:yunbiVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAsset:(EVUserAsset *)asset
{
    _asset = asset;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
