//
//  EVHVWatchStockView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchStockView.h"

#import "EVStockBaseModel.h"

//#define webUrl @"https://appgw.hooview.com/easyvaas/webapp/"
//#define webUrl @"http://dev.yizhibo.tv/hooview/stock/"
@interface EVHVWatchStockView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UITableViewDelegate,UITableViewDataSource>

@end

@implementation EVHVWatchStockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
        [self loadWebData];
    }
    return self;
}

- (void)addUpViewFrame:(CGRect)frame
{
    UITableView *searchTableView = [[UITableView  alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self addSubview:searchTableView];
    self.searchTableView  = searchTableView;
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.hidden = NO;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.searchTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.searchTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.searchTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.stockWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.stockWebView.navigationDelegate = self;    // 将WKWebView添加到视图
    self.stockWebView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.stockWebView];
    
    [self.stockWebView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.stockWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.stockWebView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.stockWebView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    
    [self updateUrlStr:@""];
    self.stockWebView.UIDelegate = self;
}

- (void)updateUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.stockWebView loadRequest:request];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"searchCell"];
    }
    cell.backgroundColor = [UIColor evBackgroundColor];
    UIView *sCotentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 30)];
    [cell addSubview:sCotentView];
    sCotentView.layer.cornerRadius = 4;
    sCotentView.layer.masksToBounds = YES;
    sCotentView.backgroundColor = [UIColor whiteColor];
    sCotentView.layer.borderColor = [UIColor evLineColor].CGColor;
    sCotentView.layer.borderWidth = 1;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [sCotentView addSubview:nameLabel];
    cell.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor evTextColorH1];
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    [sCotentView addSubview:codeLabel];
    codeLabel.textColor = [UIColor evTextColorH2];
    codeLabel.font = [UIFont systemFontOfSize:16.f];
    
    
    EVStockBaseModel *stockBaseModel = self.dataArray[indexPath.row];
    nameLabel.text = stockBaseModel.name;
    CGSize sizeOfText = [nameLabel sizeThatFits:CGSizeZero];
    codeLabel.text = stockBaseModel.symbol;
    nameLabel.frame = CGRectMake(10, 0, sizeOfText.width + 10, 30);
    codeLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, 100, 30);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseModel *baseModel = self.dataArray[indexPath.row];

    if (baseModel.symbol != 0) {
        self.searchTableView.hidden = YES;
        self.stockWebView.hidden = NO;
        [self updateUrlStr:[self requestUrlModel:baseModel]];
    }
    
    
}

- (NSString *)requestUrlModel:(EVStockBaseModel *)stockBaseModel
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *nameEncoding = [stockBaseModel.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setValue:nameEncoding forKey:@"name"];
    [params setValue:@"stock" forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%@",stockBaseModel.symbol] forKey:@"code"];
    [params setValue:@(1) forKey:@"special"];
    [params setValue:@"1" forKey:@"hidenews"];
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
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    if (self.dataArray.count != 0) {
        self.searchTableView.hidden = NO;
        self.stockWebView.hidden = YES;
    }
    [self.searchTableView reloadData];
}


- (void)loadWebData
{
    
}

@end
