//
//  EVTextLiveStockTableView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/23.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVTextLiveStockTableView.h"
#import "EVStockBaseModel.h"
#import "EVNotOpenView.h"

@interface EVTextLiveStockTableView ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic, weak) EVNotOpenView *notOpenView;
@end


@implementation EVTextLiveStockTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        EVNotOpenView *notOpenView = [[EVNotOpenView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 216)];
        [self addSubview:notOpenView];
        notOpenView.imageName = @"ic_watch_stock_not_data";
        notOpenView.titleStr = @"搜索你想了解的股票";
        self.notOpenView = notOpenView;
        notOpenView.backgroundColor = [UIColor evBackgroundColor];
        
        
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        self.stockWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 216 - 49) configuration:configuration];
        self.stockWebView.navigationDelegate = self;    // 将WKWebView添加到视图
        self.stockWebView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.stockWebView];
        self.stockWebView.hidden = YES;
        

        
        [self updateUrlStr:@""];
        self.stockWebView.UIDelegate = self;
        
    }
    return self;
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
    }
  
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVStockBaseModel *baseModel = self.dataArray[indexPath.row];
    
    if (baseModel.symbol != 0) {
        self.stockWebView.hidden = NO;
        [self.dataArray removeAllObjects];
        [self reloadData];
        [self updateUrlStr:[self requestUrlModel:baseModel]];
    }
    
    if (self.cellSelectBlock) {
        self.cellSelectBlock(baseModel);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    EVLog(@"---------- %f",scrollView.contentOffset.y);
    if (self.tDelegate  && [self.tDelegate respondsToSelector:@selector(stockViewDidScroll:)]) {
        [self.tDelegate stockViewDidScroll:scrollView];
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
    [params setValue:@(0) forKey:@"special"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",webMarketUrl,paramStr];
    
    return urlStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (dataArray.count > 0) {
        self.stockWebView.hidden = YES;
        self.notOpenView.hidden = YES;
    }else {
        self.notOpenView.hidden = NO;
        
    }
    [self reloadData];
}

- (void)removeAllAry
{
    [self.dataArray removeAllObjects];
}
@end
