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

#import "EVTopicDetailViewController.h"

#import "EVRecommendCell.h"
#import "EVOnlyTextCell.h"
#import "EVThreeImageCell.h"
#import "EVSpecialTopicCell.h"

#import "EVNewsModel.h"
#import "EVStockMarketModel.h"
#import "EVRecommendModel.h"



@interface EVImportantNewsViewController ()<UITableViewDelegate,UITableViewDataSource,EVCycleScrollViewDelegate,EVHVEyeViewDelegate>


@property (nonatomic, strong) EVCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *headScrollArray;

@property (nonatomic, strong) NSMutableArray *stockDataArray;

@property (nonatomic, strong) NSMutableArray *newsDataArray;

@property (nonatomic, strong) NSMutableArray *eyesDataArray;

/**
 牛人推荐数组
 */
@property (nonatomic, strong) NSMutableArray *recommendDataArray;

@property (nonatomic, copy) NSString *eyesID;

@property (nonatomic, strong) NSMutableArray *eyesProgramID;

@property (nonatomic, assign) int start;

@property (nonatomic, weak) UILabel *successLabel;

@property (nonatomic, strong) NSTimer *refreshTimes;

@property (nonatomic, weak) UIView *topBackView;
@end

@implementation EVImportantNewsViewController




#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView];
    [self loadImageCarousel];
    
    
    
    
    WEAK(self)
    
    [_iNewsTableview addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadImageCarousel];
        [weakself loadNewData];
    }];
    
    [_iNewsTableview addRefreshFooterWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    [self loadNewData];
    
    [self.iNewsTableview.mj_footer setHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - 🖍 User Interface layout
- (void)addTableView
{
    UITableView *iNewsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight-49-64-4) style:(UITableViewStyleGrouped)];
    
    [iNewsTableview registerNib:[UINib nibWithNibName:@"EVHVEyeViewCell" bundle:nil] forCellReuseIdentifier:@"EVHVEyeViewCell"];
    [iNewsTableview registerNib:[UINib nibWithNibName:@"EVOnlyTextCell" bundle:nil] forCellReuseIdentifier:@"EVOnlyTextCell"];
    [iNewsTableview registerNib:[UINib nibWithNibName:@"EVThreeImageCell" bundle:nil] forCellReuseIdentifier:@"EVThreeImageCell"];
    [iNewsTableview registerNib:[UINib nibWithNibName:@"EVSpecialTopicCell" bundle:nil] forCellReuseIdentifier:@"EVSpecialTopicCell"];
    [iNewsTableview registerNib:[UINib nibWithNibName:@"EVNewsListViewCell" bundle:nil] forCellReuseIdentifier:@"EVNewsListViewCell"];
    
    iNewsTableview.delegate = self;
    iNewsTableview.dataSource = self;
    iNewsTableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:iNewsTableview];
    _iNewsTableview = iNewsTableview;
    iNewsTableview.contentInset = UIEdgeInsetsMake(14, 0, 0, 0);
    EVCycleScrollView *cycleScrollView = [[EVCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.56)];
    cycleScrollView.delegate = self;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.items = self.dataArray;
    self.cycleScrollView = cycleScrollView;
    iNewsTableview.tableHeaderView = cycleScrollView;
    iNewsTableview.separatorStyle = NO;
    
    
    
    
}

#pragma mark - 🌐Networks
// 请求轮播图
- (void)loadImageCarousel
{
    WEAK(self)
    [self.baseToolManager GETCarouselInfoWithStart:^{
        
    } success:^(NSDictionary *info) {
        [weakself getCarouseInfoSuccess:info];
    } fail:^(NSError *error) {
        [EVProgressHUD showError:@"加载失败"];
    } sessionExpire:^{
        EVRelogin(weakself);
    }];
}

- (void)loadNewData
{
    _start = 0;
    
    [self.baseToolManager GETNewsRequestStart:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        [self.iNewsTableview.mj_footer resetNoMoreData];
        [self endRefreshing];
        
        [self.eyesDataArray removeAllObjects];
        [self.newsDataArray removeAllObjects];
        [self.eyesProgramID removeAllObjects];
        [self.recommendDataArray removeAllObjects];
        [self.stockDataArray removeAllObjects];
        //股市大盘
        NSArray * indexArray = retinfo[@"index"];
        if ([retinfo[@"index"] isKindOfClass:[NSArray class]]) {
            if (indexArray && indexArray.count>0)
            {
                for (NSDictionary * dic in indexArray) {
                    EVStockBaseModel *model = [EVStockBaseModel yy_modelWithDictionary:dic];
                    model.changepercent = [dic[@"changePercent"] floatValue];
                    [self.stockDataArray addObject:model];
                }
            }
        }
        
        
        //新闻列表
        NSArray * homeNewsArray = retinfo[@"homeNews"];
        if (homeNewsArray && homeNewsArray.count>0) {
            __weak typeof(self) weakSelf = self;
            [homeNewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [weakSelf.newsDataArray addObject:model];
            }];
        }
        
        //火眼金睛 新闻
        NSArray *eyesArray = retinfo[@"hooview"][@"news"];
        if (eyesArray && eyesArray.count>0) {
            for (NSDictionary * temp in eyesArray) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:temp];
                [self.eyesDataArray addObject:model];
            }
        }
        
        //火眼金睛 频道
        NSString *key = [NSString stringWithFormat:@"%@",retinfo[@"hooview"][@"channels"]];
        if (![key isEqualToString:@"<null>"] && ![key isEqualToString:@""] && key != nil) {
            self.eyesID = retinfo[@"hooview"][@"channels"][@"id"];

            NSArray *eyesProgramArr = [EVHVEyesModel objectWithDictionaryArray:retinfo[@"hooview"][@"channels"][@"Programs"]];
            [self.eyesProgramID addObjectsFromArray:eyesProgramArr];
        }
        
        //牛人推荐
        NSArray * recommendArray = retinfo[@"recommend"];
        if (recommendArray && recommendArray.count>0) {
            for (NSDictionary * temp in recommendArray) {
                EVRecommendModel * model = [EVRecommendModel yy_modelWithDictionary:temp];
                [self.recommendDataArray addObject:model];
            }
            
        }
        
        if (self.newsDataArray.count < 20)
        {
            //没有更多数据
            [self.iNewsTableview.mj_footer setHidden:YES];
        }
        else
        {
            [self.iNewsTableview.mj_footer setHidden:NO];
        }
        
        _start += self.newsDataArray.count;
        
        
        [self.iNewsTableview reloadData];
        
    } error:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"新闻请求失败"];
    }];
}

- (void)loadMoreData
{
    
    [self.baseToolManager GETNewsRequestStart:[NSString stringWithFormat:@"%d",_start] count:@"20" Success:^(NSDictionary *retinfo) {
        
        [self endRefreshing];
        
        
        //新闻列表
        NSArray * homeNewsArray = retinfo[@"homeNews"];
        if (homeNewsArray && homeNewsArray.count>0) {
            __weak typeof(self) weakSelf = self;
            [homeNewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVNewsModel * model = [EVNewsModel yy_modelWithDictionary:obj];
                [weakSelf.newsDataArray addObject:model];
            }];
        }
        
        if (homeNewsArray.count == 0)
        {
            //没有更多数据
            [self.iNewsTableview setFooterState:CCRefreshStateNoMoreData ];
        }
        else
        {
//            _start += homeNewsArray.count;
            _start += 20;
        }
        
        NSString *keyid = retinfo[@"huoyan"][@"channels"];
        if (![keyid isKindOfClass:[NSNull class]]) {
            self.eyesID = retinfo[@"huoyan"][@"channels"][@"id"];
        }
        [self.iNewsTableview reloadData];
        
    } error:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"新闻请求失败"];
    }];
}
//- (void)loadStockData
//{
//    [self.baseToolManager GETRequestHSuccess:^(NSDictionary *retinfo) {
//        [self endRefreshing];
//        NSArray *stockArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"][@"cn"]];
//        [self.stockDataArray addObjectsFromArray:stockArray];
//        [self.iNewsTableview reloadData];
//    } error:^(NSError *error) {
//        [self endRefreshing];
////        [EVProgressHUD showError:@"大盘请求失败"];
//    }];
//}



- (void)endRefreshing
{
    [_iNewsTableview endHeaderRefreshing];
    [_iNewsTableview endFooterRefreshing];
}

#pragma mark -👣 Target actions

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



#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    else if (section == 1) {
//        return 1;
//    }
    return self.newsDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        EVConsultStockViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"csCell"];
        if (!Cell) {
            Cell = [[EVConsultStockViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"csCell"];
        }
        
        if (self.stockDataArray.count != 0) {
            Cell.stockDataArray = self.stockDataArray;
        }
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.scStock = ^(EVCSStockButton *btn){
            
            EVMarketDetailsController *marketDetailVC = [[EVMarketDetailsController alloc] init];
            marketDetailVC.stockBaseModel = btn.stockBaseModel;
            if ([btn.stockBaseModel.symbol isEqualToString:@""] || btn.stockBaseModel.symbol == nil) {
                return;
            }
            [self.navigationController pushViewController:marketDetailVC animated:YES];
        };
        return Cell;
    }
//    else if (indexPath.section == 1)
//    {
//        //火眼金睛
//        EVHVEyeViewCell *eyeCell = [tableView dequeueReusableCellWithIdentifier:@"EVHVEyeViewCell"];
//        if (!eyeCell) {
//            eyeCell = [[NSBundle mainBundle] loadNibNamed:@"EVHVEyeViewCell" owner:nil options:nil][0];
//            [eyeCell setValue:@"EVHVEyeViewCell" forKey:@"reuseIdentifier"];
//        }
//        eyeCell.delegate = self;
//        eyeCell.eyesArray = self.eyesDataArray;
//        return eyeCell;
//    }
    //新闻列表
    
    EVNewsModel * newsModel = _newsDataArray[indexPath.row];
    
    if ([newsModel.type isEqualToString:@"0"])
    {
        //普通新闻
        
        if (newsModel.cover == nil || newsModel.cover.count == 0)
        {
            //没有图片
            EVOnlyTextCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"EVOnlyTextCell"];
            textCell.newsModel = newsModel;
            return textCell;
        }
        else if (newsModel.cover.count == 1)
        {
            //一张图片
            EVNewsListViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsListViewCell"];
            newsCell.consultNewsModel = newsModel;
            return newsCell;
        }
        else if (newsModel.cover.count == 3)
        {
            //三张图片
            EVThreeImageCell * threeImageCell = [tableView dequeueReusableCellWithIdentifier:@"EVThreeImageCell"];
            threeImageCell.newsModel = newsModel;
            return threeImageCell;
        }
    }
    else if([newsModel.type isEqualToString:@"1"])
    {
        //专题
        EVSpecialTopicCell * specialTopicCell = [tableView dequeueReusableCellWithIdentifier:@"EVSpecialTopicCell"];
        specialTopicCell.speciaModel = newsModel;
        return specialTopicCell;
    }
    else if ([newsModel.type isEqualToString:@"2"])
    {
        //牛人推荐
        EVRecommendCell * recommendCell = [tableView dequeueReusableCellWithIdentifier:@"EVRecommendCell"];
        if (!recommendCell) {
            recommendCell = [[EVRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVRecommendCell"];
        }
        recommendCell.recommentArray = self.recommendDataArray;
        recommendCell.didselectedIndexIWithModelBlock = ^(EVRecommendModel * model)
        {
            //选中牛人
            EVWatchVideoInfo * videoModel = [[EVWatchVideoInfo alloc] init];
            videoModel.name = model.id;
            EVVipCenterViewController *vipVC = [EVVipCenterViewController new];
            vipVC.watchVideoInfo = videoModel;
            [self.navigationController pushViewController:vipVC animated:YES];
        };
        return recommendCell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 88 + 14;
    }
//    else if (indexPath.section == 1)
//    {
//        switch (self.eyesDataArray.count)
//        {
//            case 0:
//                return 50;
//                break;
//            case 1:
//                return 100;
//                break;
//            case 2:
//                return 150;
//                break;
//            case 3:
//                return 220;
//                break;
//            default:
//                break;
//        }
//        return 200;
//    }
    EVNewsModel * newsModel = _newsDataArray[indexPath.row];
    if ([newsModel.type isEqualToString:@"2"]) {
        //牛人推荐
        return 220;
    }
    return newsModel.cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    EVNewsModel * newsModel = _newsDataArray[indexPath.row];
    
    //专题
    if ([newsModel.type floatValue] == 1) {
        EVTopicDetailViewController * topicVc = [[EVTopicDetailViewController alloc] init];
        topicVc.newsId = newsModel.newsID;
        topicVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicVc animated:YES];
    }
    else if ([newsModel.type floatValue] == 2)
    {
        //牛人推荐
        return;
    }
    else
    {
        //普通新闻
        
        EVNewsDetailWebController *newsWebVC = [[EVNewsDetailWebController alloc] init];
        newsWebVC.newsID = newsModel.newsID;
        newsWebVC.newsTitle = newsModel.title;
        if ([newsModel.newsID isEqualToString:@""] || newsModel.newsID == nil) {
            return;
        }
        newsWebVC.refreshViewCountBlock = ^()
        {
            [self loadNewData];
        };
        [self.navigationController pushViewController:newsWebVC animated:YES];
        
        
    }
}


#pragma mark - 🤝 Delegate
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

#pragma mark - 🙄 Private methods
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

#pragma mark - ✍️ Setters & Getters
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

- (NSMutableArray *)recommendDataArray
{
    if (!_recommendDataArray) {
        _recommendDataArray = [NSMutableArray array];
    }
    return _recommendDataArray;
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
#pragma mark - 🗑 CleanUp
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
