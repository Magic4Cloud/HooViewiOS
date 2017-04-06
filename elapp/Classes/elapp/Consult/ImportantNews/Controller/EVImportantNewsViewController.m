//
//  EVImportantNewsViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVImportantNewsViewController.h"
#import "EVCycleScrollView.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVCarouselItem.h"
#import "EVConsultStockViewCell.h"
#import "EVCSStockButton.h"
#import "EVHVEyeViewCell.h"
#import "EVNewsListViewCell.h"
#import "EVHVEyesViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVStockBaseModel.h"
#import "EVBaseNewsModel.h"
#import "EVHVEyesModel.h"
#import "EVNewsDetailWebController.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVMarketDetailsController.h"
#import "EVLoginInfo.h"
#import "EVDetailWebViewController.h"
#import "NSString+Extension.h"
#import "EVProgressHUD.h"
#import "EVHVWatchViewController.h"
#import "EVHVWatchTextViewController.h"
#import "EVVipCenterViewController.h"


@interface EVImportantNewsViewController ()<UITableViewDelegate,UITableViewDataSource,EVCycleScrollViewDelegate,EVHVEyeViewDelegate>

@property (nonatomic, weak) EVCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *headScrollArray;

@property (nonatomic, strong) NSMutableArray *stockDataArray;

@property (nonatomic, strong) NSMutableArray *newsDataArray;

@property (nonatomic, strong) NSMutableArray *eyesDataArray;

@property (nonatomic, copy) NSString *eyesID;

@property (nonatomic, strong) NSMutableArray *eyesProgramID;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, weak) UILabel *successLabel;

@property (nonatomic, strong) NSTimer *refreshTimes;

@property (nonatomic, weak) UIView *topBackView;
@end

@implementation EVImportantNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView];
    [self loadImageCarousel];
    [self loadStockData];
    [self loadNewsDataStart:@"0" count:@"20" showNoticeView:YES];
    
    WEAK(self)
    [_iNewsTableview addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadStockData];
        [weakself loadImageCarousel];
        [weakself loadNewsDataStart:@"0" count:@"20" showNoticeView:YES];
    }];
    
    [_iNewsTableview addRefreshFooterWithRefreshingBlock:^{
        [weakself loadNewsDataStart:self.start count:@"20" showNoticeView:NO];
    }];
    
}

- (void)timerAction
{
    [self loadStockData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewsDataStart:@"0" count:[NSString stringWithFormat:@"%ld", self.newsDataArray.count] showNoticeView:NO];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.refreshTimes = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.refreshTimes forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_refreshTimes invalidate];
//    _refreshTimes = nil;
}

- (void)addTableView
{
    UITableView *iNewsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64) style:(UITableViewStyleGrouped)];
    iNewsTableview.delegate = self;
    iNewsTableview.dataSource = self;
    iNewsTableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iNewsTableview];
    _iNewsTableview = iNewsTableview;
    iNewsTableview.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
    EVCycleScrollView *cycleScrollView = [[EVCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.56)];
    cycleScrollView.delegate = self;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.items = self.dataArray;
    self.cycleScrollView = cycleScrollView;
    _iNewsTableview.tableHeaderView = cycleScrollView;
    _iNewsTableview.separatorStyle = NO;
    [self.iNewsTableview registerNib:[UINib nibWithNibName:@"EVHVEyeViewCell" bundle:nil] forCellReuseIdentifier:@"eyeCell"];
    
    
    
    UIView *topBackView = [[UIView alloc] init];
    [self.view addSubview:topBackView];
    self.topBackView = topBackView;
    topBackView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }
    return self.newsDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EVConsultStockViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"csCell"];
        if (!Cell) {
            Cell = [[EVConsultStockViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"csCell"];
        }
        
        if (self.stockDataArray.count != 0) {
            Cell.stockDataArray = self.stockDataArray;
        }
        Cell.backgroundColor = [UIColor evBackgroundColor];
        Cell.scStock = ^(EVCSStockButton *btn){
            
            EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
            marketDetailVC.stockBaseModel = btn.stockBaseModel;
            if ([btn.stockBaseModel.symbol isEqualToString:@""] || btn.stockBaseModel.symbol == nil) {
                return;
            }
            [self.navigationController pushViewController:marketDetailVC animated:YES];
        };
        return Cell;
    }else if (indexPath.section == 1) {
        EVHVEyeViewCell *eyeCell = [tableView dequeueReusableCellWithIdentifier:@"eyeCell"];
        if (eyeCell == nil) {
            eyeCell = [[NSBundle mainBundle] loadNibNamed:@"EVHVEyeViewCell" owner:nil options:nil].firstObject;
        }
        eyeCell.delegate = self;
        eyeCell.eyesArray = self.eyesDataArray;
        eyeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return eyeCell;
    }

    EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    if (!newsCell) {
        
        newsCell = [[NSBundle mainBundle] loadNibNamed:@"EVNewsListViewCell" owner:nil options:nil].firstObject;
    }
    newsCell.searchNewsModel = self.newsDataArray[indexPath.row];
     newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return newsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    }else if (indexPath.section == 1) {
        switch (self.eyesDataArray.count) {
            case 0:
                return 50;
                break;
            case 1:
                return 100;
                break;
            case 2:
                return 150;
                break;
            case 3:
                return 220;
                break;
            default:
                break;
        }
        return 200;
    }
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return;
    }
    EVNewsDetailWebController *newsWebVC = [[EVNewsDetailWebController alloc] init];
    EVBaseNewsModel *newsModel = self.newsDataArray[indexPath.row];
    newsWebVC.newsID = newsModel.newsID;
    newsWebVC.newsTitle = newsModel.title;
    if ([newsModel.newsID isEqualToString:@""] || newsModel.newsID == nil) {
        return;
    }
     [self.navigationController pushViewController:newsWebVC animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.offsetBlock) {
        self.offsetBlock (scrollView.contentOffset.y,NO);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.offsetBlock) {
        self.offsetBlock (scrollView.contentOffset.y,YES);
    }
}
- (void)cycleScrollViewDidSelected:(EVCarouselItem *)item
                             index:(NSInteger)index
{
    if ( [item isKindOfClass:[EVCarouselItem class]] )
    {
        EVCarouselItem *carousItem = item;

        switch (carousItem.type) {
            case EVCarouselItemH5:
            {
                [self gotoActivityWebViewPageWithTitle:carousItem.title activityUrl:carousItem.resource activityId:nil shareImage:nil imageStr:carousItem.img isEnd:YES];
            }
                break;
            case EVCarouselItemNews:
            {
                EVNewsDetailWebController *newsDetailVC = [[EVNewsDetailWebController alloc] init];
//                EVBaseNewsModel *baseNewsModel = ;
                newsDetailVC.newsID = carousItem.resource;
                //    newsDetailVC.title  = baseNewsModel.title;
                if ([carousItem.resource isEqualToString:@""] || carousItem.resource== nil) {
                    return;
                }
                [self.navigationController pushViewController:newsDetailVC animated:YES];
            }
                break;
             case EVCarouselItemGoodVideo:
            {
                EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
                EVWatchVideoInfo *watchVideo = [[EVWatchVideoInfo alloc] init];
                watchVideo.vid = carousItem.resource;
                watchVideo.mode = 2;
                watchViewVC.watchVideoInfo = watchVideo;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
           
            case EVCarouselItemLiveVideo:
            {
                EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
                EVWatchVideoInfo *watchVideo = [[EVWatchVideoInfo alloc] init];
                watchVideo.vid = carousItem.resource;
                watchViewVC.watchVideoInfo = watchVideo;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case EVCarouselItemTextLive:
            {
                
                EVWatchVideoInfo *liveVideoInfo = [[EVWatchVideoInfo alloc] init];
                liveVideoInfo.liveID = carousItem.resource;
                EVHVWatchTextViewController *watchImageVC = [[EVHVWatchTextViewController alloc] init];
                UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:watchImageVC];
                [self presentViewController:navigationVC animated:YES completion:nil];
                watchImageVC.liveVideoInfo = liveVideoInfo;
            }
                break;
            case EVCarouselItemUserCenter:
            {
                EVVipCenterViewController *vipCenterVC  = [[EVVipCenterViewController alloc] init];
                [self.navigationController pushViewController:vipCenterVC animated:YES];
                vipCenterVC.watchVideoInfo.name = carousItem.resource;
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)newsButton:(UIButton *)button
{
    EVNewsDetailWebController *newsDetailVC = [[EVNewsDetailWebController alloc] init];
    EVBaseNewsModel *baseNewsModel = self.eyesDataArray[button.tag - 2000];
    newsDetailVC.newsID = baseNewsModel.newsID;
//    newsDetailVC.title  = baseNewsModel.title;
    if ([baseNewsModel.newsID isEqualToString:@""] || baseNewsModel.newsID == nil) {
        return;
    }
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

- (void)moreButton:(UIButton *)button
{
    EVHVEyesViewController *eyesVC = [[EVHVEyesViewController alloc] init];
    if (self.eyesProgramID.count <= 0) {
        [EVProgressHUD showError:@"没有更多数据"];
        return;
    }
    eyesVC.eyesArray = self.eyesProgramID;
    eyesVC.eyesID = self.eyesID;
    [self.navigationController pushViewController:eyesVC animated:YES];
  
}
// 请求轮播图
- (void)loadImageCarousel
{
    WEAK(self)
    [self.baseToolManager GETCarouselInfoWithStart:^{
        
    } success:^(NSDictionary *info) {
        [self endRefreshing];
        [weakself getCarouseInfoSuccess:info];
    } fail:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    } sessionExpire:^{
        EVRelogin(weakself);
    }];
}


- (void)loadStockData
{
     [self.baseToolManager GETRequestHSuccess:^(NSDictionary *retinfo) {
         [self endRefreshing];
         NSArray *stockArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"][@"cn"]];
         [self.stockDataArray addObjectsFromArray:stockArray];
         [self.iNewsTableview reloadData];
     } error:^(NSError *error) {
         [self endRefreshing];
         [EVProgressHUD showError:@"大盘请求失败"];
     }];
}

- (void)endRefreshing
{
    [_iNewsTableview endHeaderRefreshing];
    [_iNewsTableview endFooterRefreshing];
}

- (void)loadNewsDataStart:(NSString *)start count:(NSString *)count showNoticeView:(BOOL)showView
{
   
    
    [self.baseToolManager GETNewsRequestStart:start count:count Success:^(NSDictionary *retinfo) {
       
        
        [self endRefreshing];
        self.start = retinfo[@"next"];
        if ([retinfo[@"start"] integerValue] == 0) {
            [self.eyesDataArray removeAllObjects];
            [self.newsDataArray removeAllObjects];
            [self.eyesProgramID removeAllObjects];
        }
        if ([retinfo[@"start"] integerValue] == 0 && showView) {
//             [self successLoadView];
        }
        NSArray *newsArray = [EVBaseNewsModel objectWithDictionaryArray:retinfo[@"home_news"]];
        NSArray *eyesArray = [EVBaseNewsModel objectWithDictionaryArray:retinfo[@"huoyan"][@"news"]];
        NSString *key = [NSString stringWithFormat:@"%@",retinfo[@"huoyan"][@"channels"]];
        if (![key isEqualToString:@"<null>"] && ![key isEqualToString:@""] && key != nil) {
              NSArray *eyesProgramArr = [EVHVEyesModel objectWithDictionaryArray:retinfo[@"huoyan"][@"channels"][@"Programs"]];
             [self.eyesProgramID addObjectsFromArray:eyesProgramArr];
//             [self.iNewsTableview reloadData];
            
//             [self.iNewsTableview setFooterState:(eyesProgramArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
        }
        
        if (newsArray.count == 0) {
            //没有更多数据
            [self.iNewsTableview setFooterState:CCRefreshStateNoMoreData ];
        }
        
        NSString *keyid = retinfo[@"huoyan"][@"channels"];
        if (![keyid isKindOfClass:[NSNull class]]) {
            self.eyesID = retinfo[@"huoyan"][@"channels"][@"id"];
        }
        [self.eyesDataArray addObjectsFromArray:eyesArray];
        [self.newsDataArray addObjectsFromArray:newsArray];
        [self.iNewsTableview reloadData];
       
    } error:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"新闻请求失败"];
    }];
}

- (void)successLoadView
{
    UIView *successView = [[UIView alloc] init];
    [self.navigationController.view addSubview:successView];
    successView.frame = CGRectMake(0, 20, ScreenWidth, 20);
    successView.backgroundColor = [UIColor evMainColor];
    successView.alpha = 0.7;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"最后更新: YYYY/MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
  
    UILabel *successLabel = [[UILabel alloc] init];
    [successView addSubview:successLabel];
    self.successLabel  = successLabel;
    successLabel.frame = CGRectMake(0, 0, ScreenWidth, 20);
    successLabel.textColor = [UIColor whiteColor];
    [successLabel setText:dateString];
    successLabel.backgroundColor = [UIColor clearColor];
    successLabel.font   = [UIFont systemFontOfSize:14];
    successLabel.textAlignment = NSTextAlignmentCenter;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [successView removeFromSuperview];
    });
}
// 处理得到的轮播图
- (void)getCarouseInfoSuccess:(NSDictionary *)info
{
    NSArray *items = [EVCarouselItem objectWithDictionaryArray:info[@"data"]];
    self.cycleScrollView.items = items;
    self.headScrollArray = [items mutableCopy];
    [self.iNewsTableview reloadData];
}


// H5活动详情
- (void)gotoActivityWebViewPageWithTitle:(NSString *)title
                             activityUrl:(NSString *)activityUrl
                              activityId:(NSString *)activityId
                              shareImage:(UIImage *)shareImage
                                imageStr:(NSString *)coverImageStr
                                   isEnd:(BOOL)isEnd
{
    if (activityUrl == nil || [activityUrl isEqualToString:@""]) {
        return;
    }
    EVDetailWebViewController *detailVC = [EVDetailWebViewController activityDetailWebViewControllerWithURL:activityUrl];
    detailVC.activityTitle = title;
    detailVC.image = shareImage;
    detailVC.imageStr = coverImageStr;
    detailVC.activityId = activityId;
    detailVC.isEnd = isEnd;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}
- (NSMutableArray *)stockDataArray
{
    if (!_stockDataArray) {
        _stockDataArray = [NSMutableArray array];
    }
    return _stockDataArray;
}

- (NSMutableArray *)newsDataArray
{
    if (!_newsDataArray) {
        _newsDataArray = [NSMutableArray array];
    }
    return _newsDataArray;
}

- (NSMutableArray *)eyesDataArray
{
    if (!_eyesDataArray) {
        _eyesDataArray = [NSMutableArray array];
    }
    return _eyesDataArray;
}

- (NSMutableArray *)eyesProgramID
{
    if (!_eyesProgramID) {
        _eyesProgramID = [NSMutableArray array];
    }
    return _eyesProgramID;
}

- (void)dealloc
{
    [_refreshTimes invalidate];
    _refreshTimes = nil;
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
