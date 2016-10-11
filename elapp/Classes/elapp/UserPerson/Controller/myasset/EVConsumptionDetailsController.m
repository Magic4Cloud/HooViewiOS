//
//  EVConsumptionDetailsController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVConsumptionDetailsController.h"
#import "EVConsumptionModel.h"
#import "EVBaseToolManager.h"
#import "EVLoadingView.h"
#import "UIScrollView+GifRefresh.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "PureLayout.h"
#import "EVNullDataView.h"


@interface EVConsumptionDetailsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)     UITableView          *tableView;  /**< 数据展示列表 */
@property (nonatomic, strong)   EVBaseToolManager           *engine;    /**< 网络请求引擎 */
@property (nonatomic, weak)     EVLoadingView        *loadingView;  /**< 加载页面 */
@property (nonatomic, strong)   NSMutableArray        *consumptionArray;/**列表数组*/
@property (nonatomic, strong)   CCConsumptionModel    *consumpModel;//模型数组
@property (nonatomic,copy)      NSString              *next;
@property ( weak, nonatomic )   EVNullDataView        *nullDataView;

@property (assign, nonatomic) double totalMoney;


@property (nonatomic, assign) BOOL   refreshing;

@end
@implementation EVConsumptionDetailsController

- (void)dealloc
{
    _tableView = nil;
    [_engine cancelAllOperation];
    _engine = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (EVBaseToolManager *)engine {
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _consumptionArray = [NSMutableArray array];
    self.navigationController.navigationBarHidden = NO;
    self.title = kE_GlobalZH(@"consume_detail");
    [self setUpUI];
    [self getDataStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setUpUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    switch (self.type) {
         case EVDetailType_withdrawal:
            self.title = kE_GlobalZH(@"push_money_record");
            break;
          case EVDetailType_prepaid:
            self.title = kE_GlobalZH(@"recharge_money_record");
            break;
        default:
            break;
    }
    tableView.backgroundColor = CCBackgroundColor;
    tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdges];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    __weak typeof(self) weakself = self;
    [tableView addRefreshFooterWithRefreshingBlock:^{
        if ( weakself.refreshing ) {
            [weakself.tableView endHeaderRefreshing];
        }
        else
        {
            [weakself getDataStart:[weakself.next integerValue]];
        }
    }];
    
    [tableView addRefreshHeaderWithRefreshingBlock:^{
        if ( weakself.refreshing ) {
            [weakself.tableView endFooterRefreshing];
        }
        else
        {
            [weakself getDataStart:0];
        }
    }];
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64.f)];
    nullDataView.topImage = [UIImage imageNamed:@"home_pic_findempty"];
    switch (self.type) {

        case EVDetailType_withdrawal:
            nullDataView.title = kE_GlobalZH(@"not_money_record");
            break;
        case EVDetailType_prepaid:
            nullDataView.title = kE_GlobalZH(@"not_recharge_money_record");
            break;
        default:
            break;
    }
    [self.tableView addSubview:nullDataView];
    [nullDataView hide];
    self.nullDataView = nullDataView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.consumptionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor evTextColorH3];
        cell.detailTextLabel.font = CCNormalFont(13);
        cell.textLabel.textColor = [UIColor evTextColorH1];
        cell.textLabel.font = CCNormalFont(15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 0) {
        switch (self.type)
        {
            case EVDetailType_withdrawal://提现记录
            {
                NSString *totalStr = [NSString stringWithFormat:@"%@ %.2f元",kE_GlobalZH(@"all_money"),self.totalMoney/100.];
                cell.textLabel.text = totalStr;
            }
                break;
            case EVDetailType_prepaid://充值记录
            {
                NSString *totalStr = [NSString stringWithFormat:@"%@ %.2f元",kE_GlobalZH(@"all_recharge_money"),self.totalMoney/100.];
                cell.textLabel.text = totalStr;
                cell.accessoryView = [[UIView alloc]init];
                cell.detailTextLabel.text = nil;
            }
                break;
            default:
                self.refreshing = NO;
                break;
        }
    }
    if (indexPath.section == 1) {
        EVRecordlistItemModel *model = self.consumptionArray[indexPath.row];
        switch (self.type)
        {
            case  EVDetailType_withdrawal://提现记录
            {
                cell.textLabel.text = model.descriptionss;
                cell.detailTextLabel.text = model.time;
            }
                break;
            case  EVDetailType_prepaid://充值记录
            {
                cell.textLabel.text = model.descriptionss;
                cell.detailTextLabel.text = model.time;
                cell.accessoryView = [self createAccessoryView:model.ecoin];
            }
                break;
                
            default:
                break;
        }
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

//在这里做判断请求什么样的数据
- (void)getDataStart:(NSInteger)start
{
    self.refreshing = YES;
    switch (self.type)
    {
         case EVDetailType_withdrawal://提现记录
            [self withdrawalStart:start count:kCountNum];
            [self cashTotalMoneyData];
            break;
         case EVDetailType_prepaid://充值记录
            [self prepaidrecordsStart:start count:kCountNum];
            [self totalConsumptionData];
            break;
        default:
            self.refreshing = NO;
            break;
    }
}


//获取消费详情网络请求
- (void)consumptiondataWithStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) wself = self;
//    [self.engine  GETConsumptionDetailslistWithStart:start count:count start:^{
//        
//    } fail:^(NSError *error) {
//        [wself endRefrenshing];
//        if(wself.loadingView)
//        {
//            [wself.loadingView showFailedViewWithClickBlock:^{
//            }];
//        }
//    } success:^(NSDictionary *info) {
//        [wself requestSuccessWithIndex:start result:info];
//    } sessionExpired:^{
//        [wself endRefrenshing];
//    }];
}

- (void)totalConsumptionData
{
    WEAK(self)
//    [self.engine GETTotalConsumptMoneyStart:^{
//        
//    } fail:^(NSError *error) {
//        [weakself endRefrenshing];
//        if(weakself.loadingView)
//        {
//            [weakself.loadingView showFailedViewWithClickBlock:^{
//            }];
//        }
//    } success:^(NSDictionary *info) {
//        
//        weakself.totalMoney = [info[@"total"] doubleValue];
//        
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        
//    } sessionExpired:^{
//        [weakself endRefrenshing];
//    }];
}

//吧请求成功的处理写在一个方法里
- (void)requestSuccessWithIndex:(NSInteger)start
                         result:(NSDictionary *)info
{
    [self endRefrenshing];
    [self.loadingView destroy];
    if ( start == 0 )
    {
        [self.consumptionArray removeAllObjects];
    }
    self.next = info[kNext];
    [self.consumptionArray addObjectsFromArray:[CCConsumptionModel objectWithDictionary:info].recordlist];
    self.nullDataView.hidden = self.consumptionArray.count > 0;
    [self.tableView reloadData];
}

- (void)endRefrenshing
{
    self.refreshing = NO;
    [self.tableView endHeaderRefreshing];
    [self.tableView endFooterRefreshing];
}


//获取充值记录
- (void)prepaidrecordsStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) wself = self;
    [self.engine  GETPrepaidRecordslistWithStart:start count:count start:^{
        
    } fail:^(NSError *error) {
        [wself endRefrenshing];
        if(wself.loadingView)
        {
            [wself.loadingView showFailedViewWithClickBlock:^{
            }];
        }
    } success:^(NSDictionary *info) {
        [wself requestSuccessWithIndex:start result:info];
    } sessionExpired:^{
        [wself endRefrenshing];
    }];
}

//获取提现记录
- (void)withdrawalStart:(NSInteger)start count:(NSInteger)count
{
    __weak typeof(self) wself = self;
    [self.engine GETWithdrawallistWithStart:start count:count start:^{
        
    } fail:^(NSError *error) {
        [wself endRefrenshing];
        if(wself.loadingView)
        {
            [wself.loadingView showFailedViewWithClickBlock:^{
            }];
        }
    } success:^(NSDictionary *info) {
        [wself requestSuccessWithIndex:start result:info];
    } sessionExpired:^{
        [wself endRefrenshing];
    }];
}

- (void)cashTotalMoneyData
{
    WEAK(self)
//    [self.engine GETCashTotalMoneyStart:^{
//        
//    } fail:^(NSError *error) {
//        [weakself endRefrenshing];
//        if(weakself.loadingView)
//        {
//            [weakself.loadingView showFailedViewWithClickBlock:^{
//            }];
//        }
//    } success:^(NSDictionary *info) {
//        
//        weakself.totalMoney = [info[@"total"] doubleValue];
//        
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        
//    } sessionExpired:^{
//        [weakself endRefrenshing];
//    }];
}

//修改薏米数
- (UILabel *) createAccessoryView:(NSUInteger) num
{
    NSString *string;
    switch (self.type) {
        case EVDetailType_withdrawal:
            string = [NSString stringWithFormat:@"-%lu%@",(unsigned long)num,kE_GlobalZH(@"e_ticket")];
            break;
        case EVDetailType_prepaid:
            string = [NSString stringWithFormat:@"+%zd%@",num,kE_GlobalZH(@"e_Coin")];
            break;
        default:
            break;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 55.f)];
    label.text = string;
    label.textColor = [UIColor evMainColor];
    label.font = CCNormalFont(22);
    label.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(string.length - 2, 2)];
    label.attributedText = attStr;
    
    return label;
}

@end
