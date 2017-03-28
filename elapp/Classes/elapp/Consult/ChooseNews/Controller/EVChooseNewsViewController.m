//
//  EVChooseNewsViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVChooseNewsViewController.h"
#import "EVChooseNewsCell.h"
#import "EVNotOpenView.h"
#import "EVNullDataView.h"
#import "EVSearchStockViewController.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVChooseNewsModel.h"
#import "EVNewsDetailWebController.h"


@interface EVChooseNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, weak) EVNullDataView *twoDataView;

@end

@implementation EVChooseNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUpView];
    
    WEAK(self)
    [self.newsTableView addRefreshHeaderWithRefreshingBlock:^{
        [weakself loadDataStart:@"0"];
    }];
    
    [self.newsTableView addRefreshFooterWithRefreshingBlock:^{
        [weakself loadDataStart:weakself.start];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.offsetBlock) {
        self.offsetBlock (0,YES);
    }
    
    [self loadDataStart:@"0"];
}

- (void)loadDataStart:(NSString *)start
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ([loginInfo.sessionid isEqualToString:@""] || loginInfo.sessionid == nil) {
        self.newsTableView.hidden = NO;
        self.nullDataView.hidden =  NO;
        return;
    }
    
    WEAK(self)
    [self.baseToolManager GETChooseNewsRequestStart:start count:@"20" userid:[EVLoginInfo localObject].name Success:^(NSDictionary *retinfo) {
        NSLog(@"-----------------yyyy  %@",retinfo);
        [weakself.newsTableView endHeaderRefreshing];
        [weakself.newsTableView endFooterRefreshing];
        weakself.start = retinfo[@"next"];
        NSArray *newsData = [EVChooseNewsModel objectWithDictionaryArray:retinfo[@"news"]];
        if ( [start integerValue] == 0) {
            [weakself.dataArray removeAllObjects];
        }
        if ([start integerValue] == 0 && newsData.count <= 0) {
            weakself.twoDataView.hidden = NO;
        }else {
            weakself.twoDataView.hidden = YES;
        }
        [weakself.dataArray addObjectsFromArray:newsData];
        [weakself.newsTableView setFooterState:(newsData.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
        [self.newsTableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"%@",error);
        [weakself.newsTableView endHeaderRefreshing];
        [weakself.newsTableView endFooterRefreshing];
    }];
    
    
    
//    [self.baseToolManager GETUserCollectListType:EVCollectTypeStock start:^{
//        
//    } fail:^(NSError *error) {
//        [self.newsTableView endHeaderRefreshing];
//        [self.newsTableView endFooterRefreshing];
//    } success:^(NSDictionary *retinfo) {
//        [self.newsTableView endHeaderRefreshing];
//        [self.newsTableView endFooterRefreshing];
//        NSLog(@"retionfo------addstock---  %@",retinfo);
//        NSString *code = retinfo[@"collectlist"];
//        if (code.length == 0) {
//            self.newsTableView.hidden = NO;
//            self.nullDataView.hidden =  NO;
//        }else {
//            [self loadNewsDataSymbol:code start:@"0"];
//            self.newsTableView.hidden = NO;
//            self.nullDataView.hidden =  YES;
//        }
//    } sessionExpire:^{
//        
//    }];
}


- (void)loadNewsDataSymbol:(NSString *)symbol start:(NSString *)start
{
    WEAK(self)
    [self.baseToolManager GETConsultNewsRequestSymbol:symbol Start:start count:@"20" userid:[EVLoginInfo localObject].name Success:^(NSDictionary *retinfo) {
        NSLog(@"-----------------yyyy  %@",retinfo);
        [weakself.newsTableView endHeaderRefreshing];
        [weakself.newsTableView endFooterRefreshing];
        weakself.start = retinfo[@"next"];
        NSArray *newsData = [EVChooseNewsModel objectWithDictionaryArray:retinfo[@"news"]];
        if ( [start integerValue] == 0) {
            [weakself.dataArray removeAllObjects];
        }
        if ([start integerValue] == 0 && newsData.count <= 0) {
            weakself.twoDataView.hidden = NO;
        }else {
            weakself.twoDataView.hidden = YES;
        }
        [weakself.dataArray addObjectsFromArray:newsData];
        [weakself.newsTableView setFooterState:(newsData.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
        [self.newsTableView reloadData];
    } error:^(NSError *error) {
        [weakself.newsTableView endHeaderRefreshing];
        [weakself.newsTableView endFooterRefreshing];
    }];
}


- (void)addUpView
{
    UIImageView *topBackImage = [[UIImageView alloc] init];
    topBackImage.frame = CGRectMake(0, 0,ScreenWidth, 120);
    topBackImage.backgroundColor = [UIColor clearColor];
    topBackImage.image = [UIImage imageNamed:@"bg_optional"];
    [self.view addSubview:topBackImage];
    
    
    UITableView *newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44) style:(UITableViewStylePlain)];
    newsTableView.delegate = self;
    newsTableView.dataSource = self;
    [self.view addSubview:newsTableView];
    self.newsTableView = newsTableView;
    newsTableView.separatorStyle = NO;
    newsTableView.tableHeaderView = topBackImage;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    newsTableView.tableFooterView = footView;
    
    
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    nullDataView.frame = CGRectMake(0, 120, ScreenWidth, ScreenHeight - 164);
    nullDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    nullDataView.title = @"您还没有添加自选噢";
    nullDataView.buttonTitle = @"添加自选";
    [nullDataView addButtonTarget:self action:@selector(addNews) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nullDataView];
    self.nullDataView = nullDataView;
    
    
    EVNullDataView *twoDataView = [[EVNullDataView alloc] init];
    twoDataView.frame = CGRectMake(0, 120, ScreenWidth, ScreenHeight - 164);
    twoDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    twoDataView.title = @"自选股当前没有相关新闻";
    [self.view addSubview:twoDataView];
    self.twoDataView = twoDataView;
    twoDataView.hidden = YES;
}

- (void)addNews
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ([loginInfo.sessionid isEqualToString:@""] || loginInfo.sessionid == nil) {
     
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    EVSearchStockViewController *searchStockVC = [[EVSearchStockViewController alloc] init];
    [self.navigationController pushViewController:searchStockVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVChooseNewsCell *fastCell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
    if (fastCell == nil) {
        fastCell = [[NSBundle mainBundle] loadNibNamed:@"EVChooseNewsCell" owner:nil options:nil].firstObject;
    }
    fastCell.chooseNewsModel = self.dataArray[indexPath.row];
    fastCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return fastCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.newsTableView.estimatedRowHeight = 80;
    return self.newsTableView.rowHeight;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVChooseNewsModel *chooseNewsModel = self.dataArray[indexPath.row];
    
    EVNewsDetailWebController *newsDetailVC = [[EVNewsDetailWebController alloc] init];
    newsDetailVC.newsID = chooseNewsModel.newsID;
    newsDetailVC.newsTitle = chooseNewsModel.title;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.offsetBlock) {
        self.offsetBlock (scrollView.contentOffset.y,NO);
    }
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
