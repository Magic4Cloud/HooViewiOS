//
//  EVFastNewsViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVFastNewsViewController.h"
#import "EVFastNewsViewCell.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVFastNewsModel.h"

@interface EVFastNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *start;

@property (nonatomic, copy) NSString *count;


/**
 缓存行高
 */
@property (nonatomic, strong) NSCache * cellRowHeightCache;


@end

@implementation EVFastNewsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self addUpView];
    [self loadNewsData];
}

- (void)loadNewsData
{
    [self.newsTableView addRefreshHeaderWithRefreshingBlock:^{
       
        [self loadFastNewsStart:@"0" count:@"20"];
    }];
    
    [self.newsTableView addRefreshFooterWithRefreshingBlock:^{
       
        [self loadFastNewsStart:self.start count:@"20"];
        
    }];
    [self.newsTableView startHeaderRefreshing];
    self.newsTableView.mj_footer.hidden = YES;
}

- (void)loadFastNewsStart:(NSString *)start count:(NSString *)count
{
    [self.baseToolManager GETFastNewsRequestStart:start count:count Success:^(NSDictionary *retinfo) {
        [self.newsTableView endHeaderRefreshing];
        [self.newsTableView endFooterRefreshing];
        self.start = retinfo[@"next"];
        if ([retinfo[@"start"] integerValue] == 0) {
            [self.dataArray removeAllObjects];
        }
        NSArray *newsArray = [EVFastNewsModel objectWithDictionaryArray:retinfo[@"newsFlash"]];
        [self.dataArray addObjectsFromArray:newsArray];
        [self.newsTableView reloadData];
        self.newsTableView.mj_footer.hidden = NO;
        [self.newsTableView setFooterState:(newsArray.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } error:^(NSError *error) {
        [self.newsTableView endHeaderRefreshing];
        [self.newsTableView endFooterRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    }];
}
- (void)addUpView
{

    
    UITableView *newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49-64) style:(UITableViewStylePlain)];
    newsTableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
    newsTableView.delegate = self;
    newsTableView.dataSource = self;
    [self.view addSubview:newsTableView];
    self.newsTableView = newsTableView;
    self.newsTableView.estimatedRowHeight = 44;
    newsTableView.separatorStyle = NO;
    newsTableView.backgroundColor = [UIColor evLineColor];
    [newsTableView registerNib:[UINib nibWithNibName:@"EVFastNewsViewCell" bundle:nil] forCellReuseIdentifier:@"fastCell"];
    UIView *footView = [[UIView alloc] init];
    newsTableView.tableFooterView = footView;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVFastNewsViewCell *fastCell = [tableView dequeueReusableCellWithIdentifier:@"fastCell"];
    fastCell.selectionStyle = UITableViewCellSelectionStyleNone;
    fastCell.fastNewsModel = self.dataArray[indexPath.row];
    return fastCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * cellHeight = [self.cellRowHeightCache objectForKey:indexPath];
    if (cellHeight) {
        return [cellHeight floatValue];
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.cellRowHeightCache setObject:height forKey:indexPath];
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
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.offsetBlock) {
        self.offsetBlock (scrollView.contentOffset.y,NO);
    }
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

- (NSCache *)cellRowHeightCache
{
    if (!_cellRowHeightCache) {
        _cellRowHeightCache = [[NSCache alloc] init];
    }
    return _cellRowHeightCache;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.cellRowHeightCache removeAllObjects];
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
