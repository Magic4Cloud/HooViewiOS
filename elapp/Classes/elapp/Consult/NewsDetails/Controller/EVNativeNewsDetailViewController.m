//
//  EVNativeNewsDetailViewController.m
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeNewsDetailViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"

#import "EVStockDetailBottomView.h"
#import "EVSharePartView.h"

#import "EVNewsDetailModel.h"

#import "EVNewsTitleCell.h"
#import "EVNewsTagsCell.h"
#import "EVNewsContentCell.h"
@interface EVNativeNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,EVStockDetailBottomViewDelegate,EVWebViewShareViewDelegate>
{
    CGFloat contentHeight;
}
@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong) EVStockDetailBottomView *detailBottomView;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVNewsDetailModel * newsDetailModel;
@end

@implementation EVNativeNewsDetailViewController

#pragma mark - ♻️Lifecycle
- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contentHeight = 40;
    [self initUI];
    
    [self loadNewData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsTitleCell" bundle:nil] forCellReuseIdentifier:@"EVNewsTitleCell"];
    
    
    [self.view addSubview:self.detailBottomView];
    [self.view addSubview:self.eVSharePartView];
    
}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    [self.baseToolManager GETNewsDetailNewsID:self.newsID fail:^(NSError *error) {
        
    } success:^(NSDictionary *retinfo) {
        NSDictionary * dataDic = retinfo[@"retinfo"][@"data"];
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            _newsDetailModel = [EVNewsDetailModel yy_modelWithDictionary:dataDic];
            [self.tableView reloadData];
        }
    }];
}

- (NSString *)requestUrlID:(NSString *)ID
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:ID forKey:@"newsid"];
    [params setValue:@"news" forKey:@"page"];
    NSInteger paramCount = params.count;
    __block NSInteger index = 0;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",webNewsUrl,paramStr];
    
    return urlStr;
}

#pragma mark -👣 Target actions

#pragma mark - delegate
- (void)shareType:(EVLiveShareButtonType)type
{
    
}

- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
//    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    CGFloat documentWidth = webView.scrollView.contentSize.width;
    CGFloat documentHeight = webView.scrollView.contentSize.height;
    contentHeight = documentHeight;
    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
    [self.tableView reloadData];
}
#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //三个区   标题加详情一个   评论一个    推荐新闻一个
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row ==0)
            {
                return UITableViewAutomaticDimension;
            }
            else if (indexPath.row ==1)
            {
                EVNewsTagsCell * tagCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTagsCell"];
                if (!tagCell) {
                    tagCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTagsCell"];
                    tagCell.tagsModelArray = self.newsDetailModel.tag;
                }
                if (tagCell.cellHeight) {
                    return tagCell.cellHeight;
                }
                else
                {
                    return 100;
                }
            }
            else if (indexPath.row ==2)
            {
                return UITableViewAutomaticDimension;
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0) {
                EVNewsTitleCell * titleCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTitleCell"];
                return titleCell;
            }
            else if (indexPath.row ==1)
            {
                EVNewsTagsCell * tagCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTagsCell"];
                if (!tagCell) {
                    tagCell = [[EVNewsTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsTagsCell"];
                    tagCell.tagsModelArray = _newsDetailModel.tag;
                }
                
                return tagCell;
            }
            else if (indexPath.row == 2)
            {
                EVNewsContentCell * contentCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsContentCell"];
                if (!contentCell) {
                    contentCell = [[EVNewsContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsContentCell"];
                    contentCell.cellWebView.navigationDelegate = self;
                    
                }
                contentCell.htmlString = _newsDetailModel.content;
                return contentCell;
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 49)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _eVSharePartView.cancelShareBlock = ^() {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-49);
            }];
        };

    }
    return _eVSharePartView;
}

- (EVStockDetailBottomView *)detailBottomView
{
    if (!_detailBottomView) {
        _detailBottomView = [[EVStockDetailBottomView alloc] initWithFrame: CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) isBottomBack:YES];
        NSArray *titleArray = @[@"分享",@"收藏",@"评论"];
        NSArray *seleteTitleArr = @[@"分享",@"已收藏",@"评论"];
        NSArray *imageArray = @[@"btn_share_n",@"btn_news_collect_n",@"btn_news_comment_n"];
        NSArray *seleteImageArr = @[@"btn_share_n",@"btn_news_collecte_s",@"btn_news_comment_n"];
        [_detailBottomView addButtonTitleArray:titleArray seleteTitleArr:seleteTitleArr imageArray:imageArray seleteImage:seleteImageArr];
        _detailBottomView.backgroundColor = [UIColor whiteColor];
        _detailBottomView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _detailBottomView.backButtonClickBlock = ^()
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _detailBottomView;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
