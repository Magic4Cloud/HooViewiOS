//
//  EVNewsCommentController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsCommentController.h"
#import <WebKit/WebKit.h>

//#define webUrl @"http://dev.yizhibo.tv/hooview/stock/"

@interface EVNewsCommentController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *newsWebView;
@property (nonatomic, copy) NSString *urlStr;
@end

@implementation EVNewsCommentController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部评论";
    
    self.newsWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - 64)];
    self.newsWebView.navigationDelegate = self;    // 将WKWebView添加到视图
    
    [self.view addSubview:self.newsWebView];
    if (self.newsID != nil) {
        self.urlStr =   [self requestUrlID:self.newsID];
        [self updateUrlStr:self.urlStr];
        EVLog(@"webviewurl---- %@",self.urlStr);
    }
}

- (NSString *)requestUrlID:(NSString *)ID
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:ID forKey:@"newsid"];
    [params setValue:@"posts" forKey:@"page"];
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

- (void)updateUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.newsWebView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [EVProgressHUD showMessage:@"加载失败"];
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
